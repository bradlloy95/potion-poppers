extends CharacterBody2D

# --- Signals ---
signal ingredient_drop(ingredient)   # Emitted when ingredient is successfully dropped into cauldron

# --- Nodes & Exported Properties ---
@onready var sprite = $IngredientSprite

@export var name_id: String = "Default"    # Unique ID for this ingredient (matches Global list)
@export var texture: Texture2D:            # Assignable texture for ingredient sprite
	set(value):
		texture = value
		if sprite:
			sprite.texture = value

# --- State Variables ---
var dragging := false              # True while player is dragging the ingredient
var of = Vector2.ZERO              # Mouse offset for dragging
var speed = 400                     # Fall speed into cauldron
var start_pos : Vector2             # Starting position for reset
var in_drop = false                 # True if ingredient is inside drop zone


# --- Lifecycle ---
func _ready() -> void:
	# In editor preview: apply texture
	if Engine.is_editor_hint():
		if texture:
			sprite.texture = texture

	# Register initial position and state globally
	StateTracker.register_position(name_id, position)
	StateTracker.register_ingredient(name_id, false)

	# Assign texture in-game too
	if texture:
		sprite.texture = texture


func _process(_delta: float) -> void:
	# --- Dragging ---
	if dragging:
		position = get_global_mouse_position() - of
		# Disable cauldron collision while dragging
		$"../../Cauldron/CollisionPolygon2D".disabled = true
	else:
		$"../../Cauldron/CollisionPolygon2D".disabled = false

	# --- Dropping (simulate falling) ---
	if in_drop:
		velocity = Vector2.DOWN * speed
		move_and_slide()


# --- Input Handling ---
func _on_button_button_down() -> void:
	# Begin dragging
	dragging = true
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	# Stop dragging
	dragging = false

	if in_drop:
		# Stay where dropped
		position = get_global_mouse_position() - of
	else:
		# Reset to original spawn position
		position = StateTracker.get_position(name_id)


# --- Drop Zone Detection ---
func _on_drop_box_body_entered(_body: Node2D) -> void:
	in_drop = true
	StateTracker.register_ingredient(name_id, true)

func _on_drop_box_body_exited(_body: Node2D) -> void:
	in_drop = false
	StateTracker.register_ingredient(name_id, false)


# --- Cauldron Collision ---
func _on_cauldron_body_entered(body: Node2D) -> void:
	# Ensure body is a valid ingredient AND currently marked as inside drop zone
	if body.name_id in GameData.ingredients and StateTracker.ingredients_states[body.name_id]:
		# Unregister ingredient and notify game logic
		StateTracker.register_ingredient(name_id, false)
		ingredient_drop.emit(body)

		# Temporarily hide the ingredient
		body.visible = false
		await get_tree().create_timer(0.5).timeout

		# Reset ingredient position & show again
		body.position = StateTracker.get_position(body.name_id)
		body.visible = true
