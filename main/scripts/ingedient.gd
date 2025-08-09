
extends CharacterBody2D

signal ingredient_drop(ingredient)
@onready var sprite = $IngredientSprite

@export var name_id: String = "Default"
@export var texture : Texture2D:
	set(value):
		texture = value
		if sprite:
			sprite.texture = value
	
var dragging := false
var of = Vector2.ZERO
var speed = 400
var start_pos : Vector2
var in_drop = false

func _ready() -> void:
	if Engine.is_editor_hint():
		# Runs only in editor — useful for debugging or visual updates
		if texture:
			sprite.texture = texture
	Global.register_position(name_id, position)
	Global.register_ingredient(name_id, false)
	if texture:
		sprite.texture = texture
	
func _process(_delta: float) -> void:
	
		
	if dragging:
		position = get_global_mouse_position() - of
		$"../../Cauldron/CollisionPolygon2D".disabled = true
	else:
		$"../../Cauldron/CollisionPolygon2D".disabled = false
		
	if in_drop:
		velocity = Vector2.DOWN * speed
		move_and_slide()

func _on_button_button_down() -> void:
	dragging = true
	
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	dragging = false
	if in_drop:
		position = get_global_mouse_position() - of
	else:
		# move back to start position
		position = Global.get_position(name_id)
	


func _on_drop_box_body_entered(_body: Node2D) -> void:
	in_drop = true
	Global.register_ingredient(name_id, in_drop) 



func _on_drop_box_body_exited(_body: Node2D) -> void:
	in_drop = false
	Global.register_ingredient(name_id, in_drop) 


func _on_cauldron_body_entered(body: Node2D) -> void:
	if body.name_id in Global.ingredients and Global.ingredients_states[body.name_id] == true:
		Global.register_ingredient(name_id, false) 
		ingredient_drop.emit(body)
		body.visible = false
		# wait for item to reset
		await get_tree().create_timer(0.5).timeout
		body.position = Global.get_position(body.name_id)
		body.visible  = true
		
