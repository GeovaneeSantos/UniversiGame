extends Node2D
var quantidade_inimigos
func _process(delta: float) -> void:
	quantidade_inimigos = get_tree().get_nodes_in_group("inimigos").size()
	$ParallaxBackground/HUD/Label.text = str(quantidade_inimigos)
	if(quantidade_inimigos <= 0):
			$Area2D2/Label.text = "LIBERADO"
			$Area2D2/CollisionShape2D.disabled = false
	
func sair_fase(body: Node2D) -> void:
	ScriptGlobal.inicializar()
	get_tree().change_scene_to_file("res://cena_fase_3.tscn")
	pass # Replace with function body.
