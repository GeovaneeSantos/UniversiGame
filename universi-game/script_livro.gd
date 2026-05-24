extends Area2D
@export var loot_table: LootTable

var velocidade = 5
var direcao = 1

func _process(delta: float) -> void:
	
	if (direcao==1): #vai para direita
		global_position.x -= velocidade
		$Sprite2D.flip_h = false
	else:
		global_position.x += velocidade
		$Sprite2D.flip_h = true
	

func eliminar_inimigo(body: Node2D) -> void:
	print("--- INÍCIO DO DEBUG DE MORTE ---")
	print("O ataque bateu no nó chamado: ", body.name)
	
	var inimigo_real = body
	if body is Area2D:
		var pai = body.get_parent()
		if pai:
			if pai.has_node("Inimi"):
				inimigo_real = pai.get_node("Inimi")
				print("Encontrei o CharacterBody2D chamado 'Inimi'!")
			else:
				inimigo_real = pai
				print("Não achei 'Inimi', usando o pai: ", pai.name)

	print("Posição calculada para o drop: ", inimigo_real.global_position)

	if loot_table:
		print("Tabela de loot encontrada no Personagem!")
		var item_cena = loot_table.get_random_drop()
		
		if item_cena:
			print("Sucesso! A roleta da sorte decidiu dropar o item: ", item_cena.resource_path)
			call_deferred("_criar_drop_seguro", item_cena, inimigo_real.global_position)
		else:
			print("A roleta rodou, mas deu azar (retornou null). Nenhum item dropou.")
	else:
		print("ERRO: O personagem não tem nenhuma LootTable arrastada no Inspetor!")
		
	inimigo_real.call_deferred("queue_free")
	queue_free()
func _criar_drop_seguro(cena: PackedScene, posicao_drop: Vector2) -> void:
	var item_instanciado = cena.instantiate()
	var fase_principal = get_tree().current_scene
	print("Tentando adicionar o item diretamente na fase: ", fase_principal.name)
	fase_principal.add_child(item_instanciado)
	item_instanciado.global_position = posicao_drop
	
	print("ITEM ADICIONADO COM SUCESSO NA ÁRVORE! Posição final na tela: ", item_instanciado.global_position)
	print("--- FIM DO DEBUG DE MORTE ---")

		
	
	
