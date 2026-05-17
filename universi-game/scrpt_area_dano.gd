extends Area2D

func causar_dano(body: Node2D) -> void:
		get_tree().root.get_node("Fase_1/Personagem/CharacterBody2D").sofrer_dano()
		
		
