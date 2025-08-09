extends AnimatedSprite2D

var animations = ["first_heart_pop", "second_heart_pop", "third_heart_pop"]
var previous_lives: int
var animation_index: int = 0

func _ready() -> void:
	previous_lives = Global.lives

func _process(_delta: float) -> void:
	var current_lives = Global.lives

	# Check if the player lost a life
	if current_lives < previous_lives:
		if animation_index < animations.size():
			play(animations[animation_index])
			animation_index += 1
		else:
			print("No more animations to play.")
	
	previous_lives = current_lives
