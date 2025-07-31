extends CharacterBody2D

signal slime_drop

var dragging := false
var of = Vector2.ZERO
var speed = 400
var start_pos 
var in_drop = false
func _ready() -> void:
	start_pos = position
	
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - of
		$"../../Cauldron/CollisionShape2D".disabled = true
	else:
		$"../../Cauldron/CollisionShape2D".disabled = false
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
		position = start_pos


func _on_drop_box_body_entered(_body: Node2D) -> void:
	in_drop = true

func _on_drop_box_body_exited(_body: Node2D) -> void:
	in_drop = false

func _on_cauldron_body_entered(body: Node2D) -> void:
	if body.name == "Slime" and in_drop:
		slime_drop.emit()
		visible = false
		await get_tree().create_timer(0.5).timeout
		position = start_pos
		visible  = true
