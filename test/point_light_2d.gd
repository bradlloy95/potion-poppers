extends PointLight2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	energy = 0.9 + randf() * 0.2
