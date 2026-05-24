class_name LootTable
extends Resource

# Cria uma lista no inspetor para colocarmos vários LootItems juntos
@export var items: Array[LootItem] = []

# Essa função vai rodar a roleta e decidir qual item caiu
func get_random_drop() -> PackedScene:
	for loot in items:
		if loot == null:
			continue
			
		# Gera um número aleatório entre 0.0 e 100.0
		var roll = randf_range(0.0, 100.0)
		
		# Se o número gerado for menor ou igual à chance do item, ele dropa!
		if roll <= loot.drop_chance:
			return loot.item_scene # Retorna a cena do item para ser criada
			
	return null # Se rodar a lista toda e nenhum passar na sorte, não dropa nada
