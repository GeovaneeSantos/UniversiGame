extends Area2D

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
	if body.is_in_group("inimigos"):
			body.queue_free()
	
	
	
	
