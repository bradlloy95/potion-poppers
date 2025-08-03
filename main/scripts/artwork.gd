extends Node2D


signal ingredient_Drop(ingredient)


func emit_Signal(ingredient):
	ingredient_Drop.emit(ingredient)
	



func _on_leaf_ingredient_drop(ingredient: Variant) -> void:
	emit_Signal(ingredient)
	$Miscellaneous/splashParticles.position = ingredient.global_position
	$Miscellaneous/splashParticles.position.y += 10
	$Miscellaneous/splashParticles.emitting = true
	

#func _on_slime_ingredient_drop(ingredient: Variant) -> void:
	#emit_Signal(ingredient)
