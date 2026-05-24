extends Resource
class_name LootItem


@export var item_name: String = "Item"
@export var item_scene: PackedScene # Aqui você vai arrastar a cena (.tscn) do item
@export_range(0.0, 100.0) var drop_chance: float = 50.0 # Cria uma barra de 0 a 100 no Inspetor
