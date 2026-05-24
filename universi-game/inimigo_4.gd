extends CharacterBody2D

var gravidade = 30
var forcao_pulo = 600
@export var velocidade = 300 # Ajuste este valor se ele ficar rápido ou devagar demais
@export var comportamento = 1
@export var avancar = false

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	velocity.y += gravidade
	
	var personagem = get_tree().get_first_node_in_group("jogador")
	
	# Só executa se o personagem existir na cena
	if personagem:
		var posx_personagem = personagem.global_position.x
		var posx_inimigo    = global_position.x
		
		# Calcula a distância exata em pixels ignorando se está na esquerda ou direita
		var distancia_x = abs(posx_personagem - posx_inimigo)

		# Gerencia para onde o inimigo está olhando
		if is_on_floor():
			if posx_inimigo < posx_personagem:
				$Sprite2D.flip_h = false
				$Marker2D.position.x = -1 * abs($Marker2D.position.x) 
			elif posx_inimigo > posx_personagem:
				$Sprite2D.flip_h = true
				$Marker2D.position.x = 1 * abs($Marker2D.position.x) 
						
		# Só anda se a opção avançar for verdadeira E a distância for maior que 30
		if avancar and distancia_x > 30.0:
			if $Sprite2D.flip_h == false:
				velocity.x = velocidade
			elif $Sprite2D.flip_h == true:
				velocity.x = -velocidade
		else:
			# Se chegou a 30 pixels (ou menos) de distância, ele para de andar
			velocity.x = 0

	# Comportamentos/Animações
	if comportamento == 1:
		comportamento1()
	elif comportamento == 2:
		comportamento2()
		
	# Move e resolve colisões baseado no velocity
	move_and_slide()

func comportamento1():
	$AnimationPlayer.play("idle")

func comportamento2():
	$AnimationPlayer.play("spell")
		
func attack(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		ScriptGlobal.vidas -= 1
