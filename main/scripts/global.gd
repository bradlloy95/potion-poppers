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

func register_ingredient(name_id, state:bool):
	ingredients_states[name_id] = state

func get_state(name_id):
	return ingredients_states[name_id]
	
func register_position(name_id, position:Vector2):
	positions[name_id] = position

func get_position(name_id):
	

	return positions[name_id]
