extends DirectionalLight2D

var flicker_time := 0.0
var flicker_interval := 0.1




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flicker_time -= delta
	if flicker_time <=0:
		energy = 0.9 + randf() * 0.2
		color = Color(1.0, 0.75 + randf() * 0.1, 0.4)
		flicker_time = randf_range(0.08, 0.18)
