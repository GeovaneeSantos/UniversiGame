extends CharacterBody2D

var vidas = 20
var gravidade   = 30
var forcao_pulo = 600
var velocidade  = 600
@export var comportamento = 1
@onready var anim: AnimationPlayer = $AnimationPlayer

var sequencia_ataques: Array[String] = ["attack", "jump", "sword"]
var indice_ataque_atual: int = 0
var tempo_idle: float = 2.5
var cronometro_idle: float = 0.0
var no_estado_idle: bool = true

func _ready() -> void:
	entrar_em_idle()
	
func _process(delta: float) -> void:
	velocity.y += gravidade
	move_and_slide()
	if no_estado_idle:
		cronometro_idle += delta
		if cronometro_idle >= tempo_idle:
			no_estado_idle = false
			executar_proximo_ataque()	
			
	if vidas <= 0:
		ScriptGlobal.boss = true
		queue_free()
		
func attack(body: Node2D) -> void:
	if(body.name == "CharacterBody2D" and not ScriptGlobal.protec):
		ScriptGlobal.vidas -= 2

func entrar_em_idle() -> void:
	no_estado_idle = true
	cronometro_idle = 0.0
	anim.play("idle")
	
func executar_proximo_ataque() -> void:
	var ataque_da_vez = sequencia_ataques[indice_ataque_atual]
	anim.play(ataque_da_vez)
	indice_ataque_atual = (indice_ataque_atual + 1) % sequencia_ataques.size()
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animação que acabou de terminar: ", anim_name)
	if anim_name in sequencia_ataques:
		entrar_em_idle()
