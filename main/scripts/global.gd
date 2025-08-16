extends Node

var lives : int = 3

var ingredients = ["Mushroom", "Leaf", "Slime", "Ember Root", "Crystal Berry"]

var postions = ["Healing Brew", "Fire Tonic", "Speed Syrup", "Poison Mist"]

var postion_recipes = {
	"Healing Brew": ["Mushroom", "Leaf"],
	"Fire Tonic": ["Slime", "Ember Root"],
	"Speed Syrup": ["Crystal Berry", "Leaf"],
	"Poison Mist": ["Mushroom", "Slime"]
}
var positions = {}
var ingredients_states = {}

# stats
var highest_score: int = 0

var potions_brewed = {
	"Healing Brew": 0,
	"Fire Tonic": 0,
	"Speed Syrup": 0,
	"Poison Mist": 0
}
var potions_brewed1 = {
	"Healing Brew": 0,
	"Fire Tonic": 0,
	"Speed Syrup": 0,
	"Poison Mist": 0
}
# Savin game
const SAVE_FILE := "user://savegame.json"

func save_game():
	var data := {
		"high score": highest_score,
		"brewed potions": potions_brewed
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			highest_score = result.get("high score", 0)
			potions_brewed = result.get("brewed potions", potions_brewed)
		file.close()
		
func delete_save():
	var data := {
		"high score": 0,
		"brewed potions": {
			"Healing Brew": 0,
			"Fire Tonic": 0,
			"Speed Syrup": 0,
			"Poison Mist": 0
			}
		}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
	
func register_ingredient(name_id, state:bool):
	ingredients_states[name_id] = state

func get_state(name_id):
	return ingredients_states[name_id]
	
func register_position(name_id, position:Vector2):
	positions[name_id] = position

func get_position(name_id):
	return positions[name_id]
