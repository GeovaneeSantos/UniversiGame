extends Area2D

func coletar_vida(body: Node2D) -> void:
	if (body.name=="CharacterBody2D" && ScriptGlobal.vidas < 5):
		body.ganhar_vida()
		queue_free()	
		
