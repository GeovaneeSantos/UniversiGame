extends CharacterBody2D
var gravidade   = 30
var forcao_pulo = 600
var velocidade = 600
@export var comportamento = 1

func _process(delta: float) -> void:
	velocity.y += gravidade
	move_and_slide()
func attack(body: Node2D) -> void:
	if(body.name == "CharacterBody2D"):
		ScriptGlobal.vidas -= 1
# Replace with function body.
