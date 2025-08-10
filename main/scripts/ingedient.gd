extends CharacterBody2D

signal ingredient_drop(ingredient)

@onready var sprite = $IngredientSprite

@export var name_id: String = "Default"
@export var texture: Texture2D:
	set(value):
		texture = value
		if sprite:
			sprite.texture = value

var dragging := false              # True when the player is dragging the ingredient
var of = Vector2.ZERO              # Offset between mouse and sprite origin when dragging starts
var speed = 400                    # Fall speed when dropped
var start_pos : Vector2            # Starting position to reset when not dropped
var in_drop = false                # True if ingredient is over drop box

func _ready() -> void:
	if Engine.is_editor_hint():
		if texture:
			sprite.texture = texture

	# Register initial position and ingredient state globally
	Global.register_position(name_id, position)
	Global.register_ingredient(name_id, false)

	# Assign texture if available
	if texture:
		sprite.texture = texture

func _process(_delta: float) -> void:
	# Handle dragging logic
	if dragging:
		position = get_global_mouse_position() - of
		$"../../Cauldron/CollisionPolygon2D".disabled = true
	else:
		$"../../Cauldron/CollisionPolygon2D".disabled = false

	# Simulate dropping (falling into cauldron)
	if in_drop:
		velocity = Vector2.DOWN * speed
		move_and_slide()

func _on_button_button_down() -> void:
	# Start dragging
	dragging = true
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	# Stop dragging
	dragging = false

	if in_drop:
		# If inside drop box, just snap to mouse position
		position = get_global_mouse_position() - of
	else:
		# Reset to original position
		position = Global.get_position(name_id)

func _on_drop_box_body_entered(_body: Node2D) -> void:
	in_drop = true
	Global.register_ingredient(name_id, true)

func _on_drop_box_body_exited(_body: Node2D) -> void:
	in_drop = false
	Global.register_ingredient(name_id, false)

func _on_cauldron_body_entered(body: Node2D) -> void:
	# Check if valid ingredient and it's currently marked as in the drop zone
	if body.name_id in Global.ingredients and Global.ingredients_states[body.name_id]:
		# Unregister and emit drop signal
		Global.register_ingredient(name_id, false)
		ingredient_drop.emit(body)

		# Hide the body briefly
		body.visible = false
		await get_tree().create_timer(0.5).timeout

		# Reset ingredient position and make it visible again
		body.position = Global.get_position(body.name_id)
		body.visible = true
