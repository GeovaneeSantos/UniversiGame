extends Area2D

var velocidade = 5
var direcao = -1

func _process(delta: float) -> void:
	
	if (direcao==1): #vai para direita
		global_position.x -= velocidade
		$Sprite2D.flip_h = true
	else:
		global_position.x += velocidade
		$Sprite2D.flip_h = false


func eliminar_inimigo(body: Node2D) -> void:
	if (body.name=="CharacterBody2D"):
		if(not ScriptGlobal.protec):
			ScriptGlobal.vidas -= 1
		queue_free()
		
		
	
	
	
	
