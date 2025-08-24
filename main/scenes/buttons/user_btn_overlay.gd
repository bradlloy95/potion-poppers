extends Control

signal pause



func _on_pause_button_pressed() -> void:
	pause.emit()
