extends CanvasLayer

signal main_menu
signal Resume

func _on_resume_pressed() -> void:
	Resume.emit()


func _on_main_menu_pressed() -> void:
	main_menu.emit()


func _on_menu_btn_pressed() -> void:
	SaveManager.save_game()
