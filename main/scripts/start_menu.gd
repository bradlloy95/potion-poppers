extends Node2D

func _ready() -> void:
	StateTracker.in_game = false

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/saved_games.tscn")



func _on_stats_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/stats.tscn")


func _on_settings_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/settins.tscn")
