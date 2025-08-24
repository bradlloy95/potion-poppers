extends Node

var level : int = 1    # level X 100 to rank up (level 3 would need 300 xp)
var xp_multiplier := 100
var xp : int = 0      
var potion_made_xp = 20 
var rep : int = 0
var coins : int = 10

func _process(delta: float) -> void:
	if xp >= (level * xp_multiplier):
		var difference = xp - (level * xp_multiplier)
		level += 1
		xp = difference

# ~~ ingredients inventory and functions ~~
var ingredients_inventory = {}

func add_ingredient(key):
	pass

func remove_ingredient(key):
	pass

# ~~ potion inventory and functions ~~
var potion_inventory := {}



func add_potion(key: String):
	if key not in potion_inventory:
		potion_inventory[key] = 1
	else:
		potion_inventory[key] += 1
	print(potion_inventory)

func remove_potion(key):
	pass

var current_contracts = {}

var complete_contracts = {}


func new_game_set_up():
	level = 1
	xp = 0
	rep = 0
	coins = 10
	ingredients_inventory = {}
	potion_inventory.clear()
	#for potion in GameData.potions:
	#	potion_inventory[potion_inventory] = 0
	current_contracts = {}
	complete_contracts = {}
	SaveManager.save_game()
	
	print("New game set up")
