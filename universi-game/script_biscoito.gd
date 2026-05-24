extends Area2D
func coletar_biscoito(body: Node2D) -> void:
	if (body.name=="CharacterBody2D" && ScriptGlobal.biscoitos < 5):
		body.ganhar_biscoito()
		queue_free()
