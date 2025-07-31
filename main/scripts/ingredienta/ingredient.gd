@tool
extends CharacterBody2D

signal ingredient_Drop(ingredient)
var global_signal = GlobalSignals.ingredient_drop_in_cauldron

@onready var sprite = $Sprite2D

@export var name_id: String
@export var sprite_texture: Texture2D:
	set(value):
		sprite_texture = value
		if sprite:
			sprite.texture = value

@export var speed: int = 400

var dragging := false
var of = Vector2.ZERO
var start_pos 
var in_drop = false


func _ready() -> void:
	start_pos = position
	sprite.texture = sprite_texture
	print(name_id)
	
func _process(_delta: float) -> void:
	if dragging:
		position = get_parent().get_local_mouse_position() - of
		
	if in_drop:
		velocity = Vector2.DOWN * speed
		move_and_slide()
		

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position
	

func _on_button_button_up() -> void:
	dragging = false
	if in_drop:
		position = get_parent().get_local_mouse_position() - of
	else:
		position = start_pos
	


	


func _on_drop_box_body_exited(_body: Node2D) -> void:
	in_drop = false


func _on_cauldron_body_entered(body: Node2D) -> void:
	
	if body.name_id in Global.ingredients and in_drop:
		ingredient_Drop.emit(body)
		visible = false
		
		await get_tree().create_timer(0.5).timeout
		position = start_pos
		visible  = true


func _on_leaf_main_in_drop() -> void:
	
	in_drop = true


func _on_leaf_main_in_cauldron(body) -> void:
	if body.name_id in Global.ingredients and in_drop:
		ingredient_Drop.emit(body)
		visible = false
		
		await get_tree().create_timer(0.5).timeout
		position = start_pos
		visible  = true
