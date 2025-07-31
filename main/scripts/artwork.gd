extends Node2D

signal leaf_drop
signal slime_drop
signal ember_drop
signal mushroom_drop
signal crystal_drop
signal ingredient_Drop(ingredient)
func emit_ingredient(ingredient):
	pass	

func _on_leaf_leaf_drop() -> void:
	leaf_drop.emit()
	print("Leaf")
	


func _on_slime_slime_drop() -> void:
	slime_drop.emit()
	print("SLime")

func _on_ember_root_ember_drop() -> void:
	ember_drop.emit()
	print("ember")

func _on_mushroom_mushroom_drop() -> void:
	mushroom_drop.emit()
	print("mush")

func _on_crystal_crystal_drop() -> void:
	crystal_drop.emit()
	print("cry")


func _on_ingredient_ingredient_drop(ingredient) -> void:
	ingredient_Drop.emit(ingredient)
	print(ingredient.name_id)
