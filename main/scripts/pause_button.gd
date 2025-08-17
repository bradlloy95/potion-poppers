extends TextureButton


func _on_mouse_entered() -> void:
	scale *= 1.1


func _on_mouse_exited() -> void:
	scale /= 1.1
