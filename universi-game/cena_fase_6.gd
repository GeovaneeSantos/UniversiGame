extends Node2D

const INIMIGOS_CENAS = [
	preload("res://inimigo.tscn"),
	preload("res://inimigo2.tscn"),
	preload("res://inimigo_3.tscn"),
	preload("res://inimigo_4.tscn")
]

var quantidade_inimigos: int = 0
var total_inicial_inimigos: int = 0
var horda_spawnada: bool = false # Garante que só spawna os reforços uma vez

func _ready() -> void:
	randomize() 
	total_inicial_inimigos = get_tree().get_nodes_in_group("inimigos").size()

func _process(delta: float) -> void:
	quantidade_inimigos = get_tree().get_nodes_in_group("inimigos").size()
	$ParallaxBackground/HUD/Label.text = str(quantidade_inimigos)
	if quantidade_inimigos <= (total_inicial_inimigos / 2) and not horda_spawnada:
		horda_spawnada = true # Bloqueia para não entrar aqui de novo
		chamar_horda_reforco()
	if quantidade_inimigos <= 0:
		$Area2D2/Label.text = "LIBERADO"
		$Area2D2/CollisionShape2D.disabled = false
	else:
		$Area2D2/Label.text = "FECHADO"
		$Area2D2/CollisionShape2D.disabled = true	
		
func chamar_horda_reforco() -> void:
	for i in range(10):
		var tempo_espera = randf_range(3.0, 10.0)
		await get_tree().create_timer(tempo_espera).timeout
		spawnar_um_inimigo_aleatorio()

func spawnar_um_inimigo_aleatorio() -> void:
	var indice_aleatorio = randi() % INIMIGOS_CENAS.size()
	var cena_sorteada = INIMIGOS_CENAS[indice_aleatorio]
	var novo_inimigo = cena_sorteada.instantiate()
	var pontos = $PontosDeSpawn.get_children()
	if pontos.size() > 0:
		var ponto_sorteado = pontos[randi() % pontos.size()]
		novo_inimigo.global_position = ponto_sorteado.global_position
	else:
		novo_inimigo.global_position = Vector2(100, 100)
		print("Aviso: Crie o nó 'PontosDeSpawn' com Markers2D dentro!")
	add_child(novo_inimigo)

func sair_fase(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		ScriptGlobal.inicializar()
		get_tree().change_scene_to_file("res://cena_fase_7.tscn")
