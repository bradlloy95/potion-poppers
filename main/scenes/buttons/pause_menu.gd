extends CanvasLayer

signal main_menu
signal Resume
signal settings



func _on_resume_pressed() -> void:
	Resume.emit()


func _on_main_menu_pressed() -> void:
	main_menu.emit()



func _on_save_game_pressed() -> void:
	SaveManager.save_game(SaveManager.current_save_slot)


func _on_settings_btn_pressed() -> void:
	
	settings.emit()
	
