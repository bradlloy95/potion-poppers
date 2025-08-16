extends Node2D

func _ready() -> void:
	Global.load_game()
	print(Global.highest_score)
	print(Global.potions_brewed)
	

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/game.tscn")


func _on_delete_save_pressed() -> void:
	Global.delete_save()


func _on_stats_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/stats.tscn")
