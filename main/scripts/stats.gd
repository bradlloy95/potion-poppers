extends Node2D


func _ready() -> void:
	display_stats()

func display_stats():
	SaveManager.load_game()
	$HighScore.text = "High Score: " + str(GameData.high_score)
	var brew_potions_str: String
	for potion in GameData.brewed_potions:
		brew_potions_str = brew_potions_str + potion + ": " + str(int(GameData.brewed_potions[potion]))+ "\n" 
	$ScrollContainer/PotionsBrewed.text = str(brew_potions_str)



func _on_reset_btn_pressed() -> void:
	SaveManager.perm_delete_save()
	SaveManager.load_game()
	display_stats()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")
