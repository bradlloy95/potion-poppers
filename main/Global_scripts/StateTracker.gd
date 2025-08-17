extends Node

var ingredients_states = {}
var positions = {}

func register_ingredient(name_id, state: bool):
	ingredients_states[name_id] = state

func get_state(name_id):
	return ingredients_states.get(name_id, null)

func register_position(name_id, position: Vector2):
	positions[name_id] = position

func get_position(name_id):
	return positions.get(name_id, null)
