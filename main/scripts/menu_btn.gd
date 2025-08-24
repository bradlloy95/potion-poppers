extends TextureButton

@export var text: String = "Game Over!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = text
	
