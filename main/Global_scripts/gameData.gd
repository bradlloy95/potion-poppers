extends Node





# Ingredient list
var ingredients = ["Mushroom", "Leaf", "Slime", "Ember Root", "Crystal Berry"]

# Potion names
var potions = [
	"Healing Brew",
	"Fire Tonic",
	"Speed Syrup",
	"Poison Mist",
	#"Mystic Elixir",
	#"Inferno Potion"
]

#potions images 
var potion_images = {
	"Healing Brew": "res://assetes/images/potions/healing.png",
	"Fire Tonic": "res://assetes/images/potions/fire.png",
	"Speed Syrup": "res://assetes/images/potions/speed.png",
	"Poison Mist": "res://assetes/images/potions/poison.png",
}

# ingredients images
var ingredients_images := {
	"Mushroom": "res://assetes/images/ingredients/mushroom.png",
	"Leaf": "res://assetes/images/ingredients/leaf.png",
	"Slime": "res://assetes/images/ingredients/slime-removebg-preview-1.png.png",
	"Ember Root": "res://assetes/images/ingredients/ember (2).png",
	"Crystal Berry": "res://assetes/images/ingredients/crystal.png"	
}
# Potion recipes
var potion_recipes = {
	"Healing Brew": ["Leaf", "Mushroom"],
	"Fire Tonic": ["Ember Root","Slime"],
	"Speed Syrup": ["Crystal Berry", "Leaf"],
	"Poison Mist": ["Mushroom", "Slime"],
	#"Mystic Elixir": ["Crystal Berry", "Leaf", "Mushroom"],
	#"Inferno Potion": ["Crystal Berry", "Ember Root", "Slime"]
}
