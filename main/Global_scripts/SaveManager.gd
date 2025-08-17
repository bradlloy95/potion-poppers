extends Node

const SAVE_FILE := "user://savegame.json"
func _ready() -> void:
	load_game()
	
func save_game():
	var data = {
		"high score": GameData.high_score,
		"brewed potions": GameData.brewed_potions
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	print("game saved")
	

func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		print("No save file found, starting new game.")
		GameData.new_game_set_up()
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if typeof(result) == TYPE_DICTIONARY:
			GameData.high_score = result.get("high score", 0)
			GameData.brewed_potions = result.get("brewed potions")
		file.close()

func perm_delete_save():
	var dir = DirAccess.open("user://")
	if dir.file_exists(SAVE_FILE):
		dir.remove(SAVE_FILE)
		print("Save removed permanently.")
		GameData.new_game_set_up()
