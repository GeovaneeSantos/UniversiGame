extends CharacterBody2D

var jogador: CharacterBody2D 

@export var distancia_minima: float = 30.0 
@export var velocidade_perseguicao: float = 200.0 
@export var loot_table: Resource # Adicionado para você arrastar a sua LootTable no Inspetor

@onready var anim: AnimationPlayer = $AnimationPlayer 

var gravidade: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var usando_super: bool = false 

func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("jogador")
	anim.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravidade * delta

	if usando_super:
		velocity.x = move_toward(velocity.x, 0, velocidade_perseguicao * delta)
		move_and_slide()
		return

	if Input.is_action_just_pressed("super"):
		iniciar_super()
		return

	if not jogador:
		move_and_slide()
		return
		
	var distancia_x = abs(jogador.global_position.x - global_position.x)
	var direcao_x = jogador.global_position.x - global_position.x
	
	if distancia_x > distancia_minima:
		velocity.x = sign(direcao_x) * velocidade_perseguicao
		
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		elif velocity.x < 0:
			$Sprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, velocidade_perseguicao * delta)

	move_and_slide()
	gerenciar_animacoes()

func gerenciar_animacoes() -> void:
	if usando_super:
		return
		
	if abs(velocity.x) < 10.0:
		anim.play("idle")
	else:
		anim.play("andando")

func iniciar_super() -> void:
	usando_super = true
	velocity.x = 0 
	anim.play("latido")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "latido":
		_matar_inimigos()
		
		anim.play("idle") 
		await get_tree().create_timer(5.0).timeout
		queue_free()

func _matar_inimigos() -> void:
	var inimigos = get_tree().get_nodes_in_group("inimigos")
	var fase_atual = get_tree().current_scene # Pega a fase exata que está rodando
	
	for inimigo in inimigos:
		# Verifica se o inimigo existe E se ele é "filho" (faz parte) da fase atual
		if is_instance_valid(inimigo) and fase_atual.is_ancestor_of(inimigo):
			eliminar_inimigo(inimigo)

# --- SISTEMA DE DROPS INTEGRADO E LIMPO ---

func eliminar_inimigo(body: Node2D) -> void:
	var inimigo_real = body
	
	if body is Area2D:
		var pai = body.get_parent()
		if pai:
			if pai.has_node("Inimi"):
				inimigo_real = pai.get_node("Inimi")
			else:
				inimigo_real = pai

	if loot_table:
		var item_cena = loot_table.get_random_drop()
		if item_cena:
			call_deferred("_criar_drop_seguro", item_cena, inimigo_real.global_position)
			
	inimigo_real.call_deferred("queue_free")

func _criar_drop_seguro(cena: PackedScene, posicao_drop: Vector2) -> void:
	var item_instanciado = cena.instantiate()
	var fase_principal = get_tree().current_scene
	
	fase_principal.add_child(item_instanciado)
	item_instanciado.global_position = posicao_drop
