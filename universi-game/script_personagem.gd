extends CharacterBody2D

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
		if (Input.is_action_pressed("ui_left")):
			velocity.x = -velocidade
			$Sprite2D.flip_h = true
			$Marker2D.position.x = -1 * abs($Marker2D.position.x) # abs converter negativo para positivo
			$Area2D.position.x = -1 * abs($Area2D.position.x) # abs converter negativo para positivo
			
		if (Input.is_action_pressed("ui_right")):
			velocity.x = velocidade
			$Sprite2D.flip_h = false
			$Marker2D.position.x = abs($Marker2D.position.x) # abs converter negativo para positivo
			$Area2D.position.x = abs($Area2D.position.x) # abs converter negativo para positivo
			
		if (Input.is_action_just_pressed("ui_up") and is_on_floor()):
			get_tree().root.print_tree()
			velocity.y = -forca_pulo
			animando = false
			
		if (Input.is_action_pressed("atirar") and is_on_floor()):
			animando = true
			$AnimationPlayer.play("book_throw")
			
				
		if (Input.is_action_just_pressed("atacar") and is_on_floor()):
			animando = true
			$AnimationPlayer.play("attack")
			
			
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
		
	move_and_slide()
	
func spawnar_livro():
	var cena_livro   = preload("res://cena_livro.tscn")
	var objeto_livro = cena_livro.instantiate()
	
	if (not $Sprite2D.flip_h): # não foi flipada, então é a imagem padrão, ou seja, direita
		objeto_livro.get_node("Area2D").direcao = -1
	else:
		objeto_livro.get_node("Area2D").direcao = 1
	
	print(objeto_livro.get_node("Area2D").direcao)
	
	add_sibling(objeto_livro)
	objeto_livro.global_position = $Marker2D.global_position
	
func eliminar_inimigo(body: Node2D) -> void:
	if (body.name=="Inimigo"):
		body.queue_free()
		ScriptGlobal.inimigos_fase1 -= 1
		
func ir_para_gamer_over():
	get_tree().change_scene_to_file("res://cena_game_over.tscn")
				
func sofrer_dano():
	#if (colidindo_com_inimigo):
		print("dano")
		ScriptGlobal.vidas -= valor_dano
		#$AnimationPlayerDano.play("dano")

func ganhar_vida():
	$AudioStreamPlayer_ganha_vida.play()
	ScriptGlobal.qtd_vidas += 1
	

	
	
	
	
