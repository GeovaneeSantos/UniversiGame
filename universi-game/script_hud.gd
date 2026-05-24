extends Node2D

# Criamos listas com as referências dos nós para facilitar o controle
@onready var sprites_vida = [$Vida, $Vida2, $Vida3, $Vida4, $Vida5]
@onready var sprites_biscoito = [$Biscoito, $Biscoito2, $Biscoito3, $Biscoito4, $Biscoito5]

func _process(_delta: float) -> void:
	atualizar_interface_vida()
	atualizar_interface_biscoito()
	if(ScriptGlobal.biscoitos>= 5): 
		$dog.visible = true
		$Dica.visible = true
	else:
		$dog.visible = false
		$Dica.visible = false
func atualizar_interface_vida() -> void:
	# O loop roda 5 vezes (índices de 0 a 4)
	for i in range(sprites_vida.size()):
		# Se o índice atual for menor que a quantidade de vidas, o sprite fica visível.
		# Exemplo: Se vidas = 3, os índices 0, 1 e 2 ficam visíveis. O 3 e 4 ficam invisíveis.
		sprites_vida[i].visible = i < ScriptGlobal.vidas

func atualizar_interface_biscoito() -> void:
	# A mesma lógica se aplica aos biscoitos
	for i in range(sprites_biscoito.size()):
		sprites_biscoito[i].visible = i < ScriptGlobal.biscoitos
