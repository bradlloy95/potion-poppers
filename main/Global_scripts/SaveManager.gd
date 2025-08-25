extends Node

const SAVE_FILE := "user://savegame.json"
var cureent_save_date := {}
var todays_date := {}
var current_save_slot : String
var save_slots = {
	"save slot 1": {"path": "user://saveslot1.json", "has save": false},
	"save slot 2": {"path": "user://saveslot2.json", "has save": false},
	"save slot 3": {"path": "user://saveslot3.json", "has save": false}
}

func _ready() -> void:
	for save in save_slots:
		var path = save_slots[save]["path"]
		if FileAccess.file_exists(path):
			save_slots[save]["has save"] = true
			# Load minimal data (level + date) for UI
			var file = FileAccess.open(path, FileAccess.READ)
			if file:
				var result = JSON.parse_string(file.get_as_text())
				if typeof(result) == TYPE_DICTIONARY:
					save_slots[save]["level"] = result.get("level", 0)
					var date = result.get("date", {})
					save_slots[save]["save date"] = format_date(date)
			file.close()
		else:
			save_slots[save]["has save"] = false
			save_slots[save]["level"] = null
			save_slots[save]["save date"] = "Empty"

	todays_date = Time.get_datetime_dict_from_system()


func save_game(save_slot):
	var save_path = save_slots[save_slot]["path"]
	var data = {
		"level": PlayerStats.level,
		"xp": PlayerStats.xp,
		"rep": PlayerStats.rep,
		"coins": PlayerStats.coins,
		"ingredients inventory": PlayerStats.ingredients_inventory,
		"potion inventory": PlayerStats.potion_inventory,
		"current contracts": PlayerStats.current_contracts,
		"complete contracts": PlayerStats.complete_contracts,
		"date": todays_date
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		
	print("game saved to " + save_path)
	save_slots[save_slot]["has save"] = true
	save_slots[save_slot]["level"] = PlayerStats.level
	save_slots[save_slot]["save date"] = format_date(todays_date)
	
	current_save_slot = save_slot


func perm_delete_save(save_slot):
	var save_path = save_slots[save_slot]["path"]
	var dir = DirAccess.open("user://")
	if dir.file_exists(save_path):
		dir.remove(save_path)
		print("Save removed permanently.")
		save_slots[save_slot]["has save"] = false 
		save_slots[save_slot]["level"] = null
		save_slots[save_slot]["save date"] = "Empty"


func load_game_save_slot(save_slot):
	var save_path = save_slots[save_slot]["path"]
	
	if not FileAccess.file_exists(save_path):
		print("No save file found, starting new game.")
		PlayerStats.new_game_set_up(save_slot)
		return
		
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if typeof(result) == TYPE_DICTIONARY:
			PlayerStats.level = result.get("level", 0)
			PlayerStats.xp = result.get("xp", 0)
			PlayerStats.rep = result.get("rep", 0)
			PlayerStats.coins = result.get("coins", 0)
			PlayerStats.ingredients_inventory = result.get("ingredients inventory", {})
			PlayerStats.potion_inventory = result.get("potion inventory", {})
			PlayerStats.current_contracts = result.get("current contracts", [])
			PlayerStats.complete_contracts = result.get("complete contracts", [])
			cureent_save_date = result.get("date", {})
			current_save_slot = save_slot
			
			# update dictionary for UI
			save_slots[save_slot]["level"] = PlayerStats.level
			save_slots[save_slot]["save date"] = format_date(cureent_save_date)
			
		file.close()
		print("Loaded from: ", save_path)
	else:
		print("Could not open file: ", save_path)


# Helper function to format datetime dict -> string
func format_date(date: Dictionary) -> String:
	if date.is_empty():
		return "No Save"
	return "%02d/%02d/%d %02d:%02d" % [
		date.get("day", 0),
		date.get("month", 0),
		date.get("year", 0),
		date.get("hour", 0),
		date.get("minute", 0)
	]
