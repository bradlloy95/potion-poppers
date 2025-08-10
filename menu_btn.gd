extends TextureButton

@export var text: String = "Game Over!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
