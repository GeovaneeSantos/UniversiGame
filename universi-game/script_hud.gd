extends Node2D

# Criamos listas com as referências dos nós para facilitar o controle
@onready var sprites_vida = [$Vida, $Vida2, $Vida3, $Vida4, $Vida5]
@onready var sprites_biscoito = [$Biscoito, $Biscoito2, $Biscoito3, $Biscoito4, $Biscoito5]
const CENA_BALAO = preload("res://cena_balao_dica.tscn")

# Referência para o painel de pause que criamos na interface
@onready var painel_pause = $PainelPause

var lista_dicas: Array[String] = [
	"Aperte a BARRA DE ESPAÇO para atacarr!",
	"Aperte F para lançar um livro!",
	"Aperte SETA PARA BAIXO⬇ para se proteger!",
	"Pegue o máximo de biscoitos que conseguir",
	"Mostre para eles que você não é um BETA",
	"Seu nível de Aura caiu para valores negativos depois dessa...",
	"Mostre para eles quem é o verdadeiro Sigma dessa fase!",
	"Atenção: Morrer para o primeiro inimigo drena -10000 de Aura instantaneamente.",
	"Apenas um Beta legítimo fugiria desse combate.",
	"Um verdadeiro Sigma não cai no mesmo buraco duas vezes. Você caiu três.",
	"O inimigo pode ter tirado sua vida, mas jamais tirará seu foco betinha.",
	"Como dizia o grande filósofo Jalim Rabei: 'Quem muito corre, menos ataca'.",
	"Segundo os ensinamentos de Volim Raba: 'A defesa é a arte de não tomar dano'.",
	"Já dizia o mestre: 'Pular na hora certa evita o Game Over'.",
	"Lembre-se do conselho de Elasmo Tando: 'Se sua vida chegar a zero, você perde'."
]

var dica_atual_indice: int = 0
var maximo_dicas: int = 3

func _ready() -> void:
	comecar_ciclo_de_dicas()
	
func _process(_delta: float) -> void:
	atualizar_interface_vida()
	atualizar_interface_biscoito()
	
	if ScriptGlobal.biscoitos >= 5: 
		$dog.visible = true
		$Dica.visible = true
	else:
		$dog.visible = false
		$Dica.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		alternar_pause()

func alternar_pause() -> void:
	var novo_estado = !get_tree().paused
	get_tree().paused = novo_estado

	if painel_pause:
		painel_pause.visible = novo_estado

func atualizar_interface_vida() -> void:
	for i in range(sprites_vida.size()):
		sprites_vida[i].visible = i < ScriptGlobal.vidas

func atualizar_interface_biscoito() -> void:
	for i in range(sprites_biscoito.size()):
		sprites_biscoito[i].visible = i < ScriptGlobal.biscoitos
		
func comecar_ciclo_de_dicas() -> void:
	for i in range(maximo_dicas):
		await get_tree().create_timer(10.0).timeout
		
		if get_tree().get_nodes_in_group("jogador").size() <= 0:
			break
			
		var balao_instanciado = CENA_BALAO.instantiate()
		
		dica_atual_indice = randi() % lista_dicas.size()
		var texto_sorteado = lista_dicas[dica_atual_indice]
		
		balao_instanciado.definir_texto(texto_sorteado)
		
		if has_node("PosicaoDica"):
			$PosicaoDica.add_child(balao_instanciado)
			
		balao_instanciado.position = Vector2.ZERO
		
		var tempo_na_tela = randf_range(6.0, 10.0)
		await get_tree().create_timer(tempo_na_tela).timeout
		
		if is_instance_valid(balao_instanciado):
			balao_instanciado.queue_free()
