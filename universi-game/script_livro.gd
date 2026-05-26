extends Area2D

@export var loot_table: LootTable

var velocidade = 5
var direcao = 1

func _process(delta: float) -> void:
	if (direcao==1):
		global_position.x -= velocidade
		$Sprite2D.flip_h = false
	else:
		global_position.x += velocidade
		$Sprite2D.flip_h = true

func eliminar_inimigo(body: Node2D) -> void:
	var inimigo_real = body
	if body is Area2D:
		var pai = body.get_parent()
		if pai:
			if pai.has_node("Inimi"):
				inimigo_real = pai.get_node("Inimi")
			else:
				inimigo_real = pai

	# LÓGICA DO BOSS: Se for o Boss, apenas tira vida e some com o projétil
	if inimigo_real.is_in_group("boss") or inimigo_real.name == "Boss":
		if "vidas" in inimigo_real:
			inimigo_real.vidas -= 1
		queue_free() # Destrói o projétil/livro
		return # Sai da função para não dar insta-kill no Boss

	# Se for um inimigo comum, continua o comportamento padrão de dar insta-kill e dropar item:
	if loot_table:
		var item_cena = loot_table.get_random_drop()
		if item_cena:
			call_deferred("_criar_drop_seguro", item_cena, inimigo_real.global_position)
		
	inimigo_real.call_deferred("queue_free")
	queue_free()

func _criar_drop_seguro(cena: PackedScene, posicao_drop: Vector2) -> void:
	var item_instanciado = cena.instantiate()
	var fase_principal = get_tree().current_scene
	fase_principal.add_child(item_instanciado)
	item_instanciado.global_position = posicao_drop
