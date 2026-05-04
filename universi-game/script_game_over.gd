extends Node2D


func restart() -> void:
	ScriptGlobal.inicializar() 
	get_tree().change_scene_to_file("res://cena_inicio.tscn")
	# Replace with function body.
