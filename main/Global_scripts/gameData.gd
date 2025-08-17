extends Node

# Game variables
var lives : int = 3
var high_score : int = 0
var brewed_potions = {}

# Ingredient list
var ingredients = ["Mushroom", "Leaf", "Slime", "Ember Root", "Crystal Berry"]

# Potion names
var potions = [
	"Healing Brew",
	"Fire Tonic",
	"Speed Syrup",
	"Poison Mist",
	"Mystic Elixir",
	"Inferno Potion"
]

# Potion recipes
var potion_recipes = {
	"Healing Brew": ["Mushroom", "Leaf"],
	"Fire Tonic": ["Slime", "Ember Root"],
	"Speed Syrup": ["Crystal Berry", "Leaf"],
	"Poison Mist": ["Mushroom", "Slime"],
	"Mystic Elixir": ["Mushroom", "Leaf", "Crystal Berry"],
	"Inferno Potion": ["Slime", "Ember Root", "Crystal Berry"]
}
func _ready() -> void:
	print(brewed_potions)
	

func new_game_set_up():
	brewed_potions.clear()
	for potion in potions:
		brewed_potions[potion] = 0
	high_score = 0
	SaveManager.save_game()
	print(brewed_potions)
	print("New game set up")
