extends Node2D
func _process(delta: float) -> void:
	if(ScriptGlobal.inimigos_fase1 <= 0):
			$Area2D2/Label.text = "LIBERADO"
			$Area2D2/CollisionShape2D.disabled = false
func sair_fase(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://cena_fase_2.tscn")

	
	
