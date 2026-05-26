extends Node2D

func _on_button_pressed() -> void:
	ScriptGlobal.inicializar() 
	get_tree().change_scene_to_file("res://cena_inicio.tscn")
