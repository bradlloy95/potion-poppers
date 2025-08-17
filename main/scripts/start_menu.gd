extends Node2D

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/game.tscn")


func _on_delete_save_pressed() -> void:
	SaveManager.delete_save()


func _on_stats_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/stats.tscn")


func _on_button_pressed() -> void:
	SaveManager.perm_delete_save()


func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/settins.tscn")
