extends Node2D

const INIMIGOS_CENAS = [
	preload("res://inimigo.tscn"),
	preload("res://inimigo2.tscn"),
	preload("res://inimigo_3.tscn"),
	preload("res://inimigo_4.tscn")
]
const CENA_BOSS = preload("res://boss.tscn")

var quantidade_inimigos: int = 0
var total_inicial_inimigos: int = 0

# Controles de fluxo da fase
var horda_spawnada: bool = false 
var horda_terminou_de_spawnar: bool = false
var aguardando_boss: bool = false
var boss_spawnado: bool = false
var mudando_para_fim: bool = false

func _ready() -> void:
	randomize() 
	total_inicial_inimigos = get_tree().get_nodes_in_group("inimigos").size()

func _process(delta: float) -> void:
	# NOVA VERIFICAÇÃO: Checa se a variável global do boss ativou a vitória
	if ScriptGlobal.boss == true and not mudando_para_fim:
		ScriptGlobal.boss = false
		finalizar_fase()
		
	quantidade_inimigos = get_tree().get_nodes_in_group("inimigos").size()
	
	if has_node("ParallaxBackground/HUD/Label"):
		$ParallaxBackground/HUD/Label.text = str(quantidade_inimigos)
		
	# Gatilho para chamar os reforços (metade dos inimigos iniciais)
	if quantidade_inimigos <= (total_inicial_inimigos / 2) and not horda_spawnada:
		horda_spawnada = true 
		chamar_horda_reforco()
		
	# Gatilho após eliminar absolutamente todos os inimigos da horda
	if horda_terminou_de_spawnar and quantidade_inimigos == 0 and not aguardando_boss and not boss_spawnado:
		aguardando_boss = true
		sequencia_spawn_boss()

func chamar_horda_reforco() -> void:
	# Como você deixou range(0), a horda será pulada (ótimo para testar o Boss mais rápido!)
	for i in range(20):
		var tempo_espera = randf_range(3.0, 5.0)
		await get_tree().create_timer(tempo_espera).timeout
		spawnar_um_inimigo_aleatorio()
	horda_terminou_de_spawnar = true

func spawnar_um_inimigo_aleatorio() -> void:
	var indice_aleatorio = randi() % INIMIGOS_CENAS.size()
	var cena_sorteada = INIMIGOS_CENAS[indice_aleatorio]
	var novo_inimigo = cena_sorteada.instantiate()
	
	var pontos = $PontosDeSpawn.get_children() if has_node("PontosDeSpawn") else []
	if pontos.size() > 0:
		var ponto_sorteado = pontos[randi() % pontos.size()]
		novo_inimigo.global_position = ponto_sorteado.global_position
	else:
		novo_inimigo.global_position = Vector2(100, 100)
		
	add_child(novo_inimigo)

func sequencia_spawn_boss() -> void:
	# 1. Aguarda 7 segundos após a limpa total de inimigos
	await get_tree().create_timer(7.0).timeout
	
	# 2. Criação dinâmica do container da imagem para piscar na tela
	var camada_interface = CanvasLayer.new()
	var retangulo_imagem = TextureRect.new()
	
	retangulo_imagem.texture = load("res://Imagens/image.jpeg")
	retangulo_imagem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	retangulo_imagem.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	retangulo_imagem.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	camada_interface.add_child(retangulo_imagem)
	add_child(camada_interface)
	
	# 3. Realiza 5 pisques lentos (exibe por 0.6s, oculta por 0.6s)
	for i in range(5):
		retangulo_imagem.visible = true
		await get_tree().create_timer(0.6).timeout
		retangulo_imagem.visible = false
		await get_tree().create_timer(0.6).timeout
		
	camada_interface.queue_free()
	var novo_boss = CENA_BOSS.instantiate()
	novo_boss.add_to_group("boss") 
	novo_boss.tree_exited.connect(finalizar_fase)
	# ------------------------------
	
	var pontos = $PontosDeSpawn.get_children() if has_node("PontosDeSpawn") else []
	if pontos.size() > 0:
		var ponto_sorteado = pontos[randi() % pontos.size()]
		novo_boss.global_position = ponto_sorteado.global_position
	else:
		novo_boss.global_position = Vector2(100, 100)
		
	add_child(novo_boss)
	boss_spawnado = true

func finalizar_fase() -> void:
	# Trava de segurança: garante que o timer não seja chamado mais de uma vez
	if mudando_para_fim: return 
	mudando_para_fim = true

	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://cena_fim.tscn")

func sair_fase(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		ScriptGlobal.inicializar()
		get_tree().change_scene_to_file("res://cena_fase_7.tscn")
