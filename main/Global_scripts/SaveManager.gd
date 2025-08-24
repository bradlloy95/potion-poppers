extends Node

const SAVE_FILE := "user://savegame.json"
func _ready() -> void:
	load_game()
	
func save_game():
	var data = {
		"level": PlayerStats.level,
		"xp": PlayerStats.xp,
		"rep": PlayerStats.rep,
		"coins": PlayerStats.coins,
		"ingredients inventory": PlayerStats.ingredients_inventory,
		"potion inventory": PlayerStats.potion_inventory,
		"current contracts": PlayerStats.current_contracts,
		"complete contracts": PlayerStats.complete_contracts
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	print("game saved")
	

func load_game():
	if not FileAccess.file_exists(SAVE_FILE):
		print("No save file found, starting new game.")
		PlayerStats.new_game_set_up()
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if typeof(result) == TYPE_DICTIONARY:
			PlayerStats.level = result.get("level", 0)
			PlayerStats.xp = result.get("xp", 0)
			PlayerStats.rep = result.get("rep", 0)
			PlayerStats.coins = result.get("coins", 0)
			PlayerStats.ingredients_inventory = result.get("ingredients inventory")
			PlayerStats.potion_inventory = result.get("potion inventory", {})
			PlayerStats.current_contracts = result.get("current contracts")
			PlayerStats.complete_contracts = result.get("complete contracts")
			
		file.close()
		print(PlayerStats.potion_inventory)

func perm_delete_save():
	var dir = DirAccess.open("user://")
	if dir.file_exists(SAVE_FILE):
		dir.remove(SAVE_FILE)
		print("Save removed permanently.")
		PlayerStats.new_game_set_up()
