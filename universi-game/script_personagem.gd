extends CharacterBody2D
@export var loot_table: LootTable
var colidindo_com_inimigo = false
var valor_dano = 1

var velocidade = 300
var forca_pulo = 900
var gravidade  = 40
var vivo = true
@export var animando = false



func _process(delta: float) -> void:
	velocity.x = 0
	velocity.y += gravidade
	
	if(colidindo_com_inimigo):
		print("teste")
		
	if (ScriptGlobal.vidas<=0 and vivo):
		ScriptGlobal.vidas = 0
		$AnimationPlayer.play("death")
		vivo = false
	
	if (vivo):
		if (Input.is_action_pressed("ui_left") and not ScriptGlobal.protec):
			velocity.x = -velocidade
			$Sprite2D.flip_h = true
			$Marker2D.position.x = -1 * abs($Marker2D.position.x) # abs converter negativo para positivo
			$Area2D.position.x = -1 * abs($Area2D.position.x) # abs converter negativo para positivo
			
		if (Input.is_action_pressed("ui_right") and not ScriptGlobal.protec):
			velocity.x = velocidade
			$Sprite2D.flip_h = false
			$Marker2D.position.x = abs($Marker2D.position.x) # abs converter negativo para positivo
			$Area2D.position.x = abs($Area2D.position.x) # abs converter negativo para positivo
			
		if (Input.is_action_just_pressed("ui_up") and is_on_floor() and not ScriptGlobal.protec):
			velocity.y = -forca_pulo
			animando = false	
			
		if (Input.is_action_pressed("atirar") and is_on_floor() and not ScriptGlobal.protec):
			animando = true
			$AnimationPlayer.play("book_throw")
			
				
		if (Input.is_action_just_pressed("atacar") and is_on_floor()  and not ScriptGlobal.protec):
			animando = true
			$AnimationPlayer.play("attack")
			
		if (Input.is_action_pressed("defesa")):
			$Sprite2D2.visible = true
			ScriptGlobal.protec = true
		else:
			$Sprite2D2.visible = false
			ScriptGlobal.protec = false
			
		var anim_atual = $AnimationPlayer.current_animation
		if (anim_atual=="book_throw" || anim_atual=="attack"):
			velocity.x = 0
		
		if (not animando):
			if (is_on_floor()):
				if (velocity.x == 0):
					$AnimationPlayer.play("idle")
				else:
					$AnimationPlayer.play("walk")
			else:
				$AnimationPlayer.play("jump")	
				
		if(ScriptGlobal.biscoitos >= 5 and Input.is_action_just_pressed("atacar") and is_on_floor()  and not ScriptGlobal.protec):
					ScriptGlobal.biscoitos = 0
					var cena_cachorro   = preload("res://cena_cachorro.tscn")
					var objeto_cachorro = cena_cachorro.instantiate()
					add_sibling(objeto_cachorro)
					var posicao_atras_x = -100	
					if($Sprite2D.flip_h == false):
						posicao_atras_x = -100
					else:
						posicao_atras_x = 100
					
					objeto_cachorro.global_position = global_position + Vector2(posicao_atras_x, 0)
					ScriptGlobal.biscoitos -= 5
			
	move_and_slide()
	
func spawnar_livro():
	var cena_livro   = preload("res://cena_livro.tscn")
	var objeto_livro = cena_livro.instantiate()
	
	if (not $Sprite2D.flip_h): # não foi flipada, então é a imagem padrão, ou seja, direita
		objeto_livro.get_node("Area2D").direcao = -1
	else:
		objeto_livro.get_node("Area2D").direcao = 1
	
	add_sibling(objeto_livro)
	objeto_livro.global_position = $Marker2D.global_position
	
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

func _criar_drop_seguro(cena: PackedScene, posicao_drop: Vector2) -> void:
	var item_instanciado = cena.instantiate()
	var fase_principal = get_tree().current_scene
	print("Tentando adicionar o item diretamente na fase: ", fase_principal.name)
	fase_principal.add_child(item_instanciado)
	item_instanciado.global_position = posicao_drop
	
	print("ITEM ADICIONADO COM SUCESSO NA ÁRVORE! Posição final na tela: ", item_instanciado.global_position)
	print("--- FIM DO DEBUG DE MORTE ---")

		
func ir_para_gamer_over():
	get_tree().change_scene_to_file("res://cena_game_over.tscn")
				
func ganhar_vida():
	ScriptGlobal.vidas += 1
	$AudioStreamPlayer_ganha_vida.play()
	
func ganhar_biscoito():
	ScriptGlobal.biscoitos += 1
	$AudioStreamPlayer_ganha_vida.play()
 	
