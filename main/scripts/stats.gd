extends Node2D


func _ready() -> void:
	display_stats()

func display_stats():
	Global.load_game()
	$HighScore.text = "High Score: " + str(Global.highest_score)
	var brew_potions_str: String
	for potion in Global.potions_brewed:
		brew_potions_str = brew_potions_str + potion + ": " + str(int(Global.potions_brewed[potion]))+ "\n" 
	$PotionsBrewed.text = str(brew_potions_str)



func _on_reset_btn_pressed() -> void:
	Global.delete_save()
	Global.load_game()
	display_stats()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")
