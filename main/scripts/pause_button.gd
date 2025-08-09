extends Node2D

signal pause_pressed


func _on_button_mouse_entered() -> void:
	$Sprite2D.scale = Vector2(0.5,0.5)
	
	


func _on_button_mouse_exited() -> void:
	$Sprite2D.scale = Vector2(0.4,0.4)


func _on_button_pressed() -> void:
	pause_pressed.emit()
