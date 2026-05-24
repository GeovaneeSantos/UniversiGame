extends CharacterBody2D
var gravidade   = 30
var forcao_pulo = 600
var velocidade = 600
@export var comportamento = 1

func _process(delta: float) -> void:
	velocity.y += gravidade
	var personagem = get_tree().get_first_node_in_group("jogador") # Permite acessar qualquer nó, bastar informar o caminho
	if (is_on_floor()):
		var posx_personagem = personagem.global_position.x
		var posx_inimigo    = global_position.x
		if (posx_inimigo<posx_personagem):
			$Sprite2D.flip_h = false
			$Marker2D.position.x = -1 * abs($Marker2D.position.x) # abs converter negativo para positivo

		elif (posx_inimigo>posx_personagem):
			$Sprite2D.flip_h = true
			$Marker2D.position.x = 1 * abs($Marker2D.position.x) # abs converter negativo para positivo
	if (comportamento==1):
		comportamento1()
	elif(comportamento==2):
		comportamento2()
	move_and_slide()
func comportamento1():
		$AnimationPlayer.play("idle")
func comportamento2():
		$AnimationPlayer.play("spell")
		
func spell():
	var cena_spell  = preload("res://magia_2.tscn")
	var objeto_spell = cena_spell.instantiate()
	
	if (not $Sprite2D.flip_h): # não foi flipada, então é a imagem padrão, ou seja, direita
		objeto_spell.get_node("Area2D").direcao = -1
	else:
		objeto_spell.get_node("Area2D").direcao = 1
	
	add_sibling(objeto_spell)
	objeto_spell.global_position = $Marker2D.global_position
