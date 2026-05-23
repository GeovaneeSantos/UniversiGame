extends Node2D

func _process(delta: float) -> void:
	if(ScriptGlobal.vidas == 1):
		$Vida.visible = true	
		$Vida2.visible = false
		$Vida3.visible = false
	elif(ScriptGlobal.vidas == 2):
		$Vida.visible = true
		$Vida2.visible = true
		$Vida3.visible = false
	elif(ScriptGlobal.vidas == 3):
		$Vida.visible = true
		$Vida2.visible = true
		$Vida3.visible = true
	else:
		$Vida.visible = false
		$Vida2.visible = false
		$Vida3.visible = false
					
		
