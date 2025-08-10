extends Node2D

signal pause_pressed


func _on_button_mouse_entered() -> void:
	$Sprite2D.scale = Vector2(2.0,2.0)
	
	


func _on_button_mouse_exited() -> void:
	$Sprite2D.scale = Vector2(1.8,1.8)


func _on_button_pressed() -> void:
	pause_pressed.emit()
