extends Node2D

@export var sprite_texture = Texture2D
var pos = Vector2(648.0,240.0)
func _ready() -> void:
	print(sprite_texture)
	if sprite_texture:
		$PotionSprite.texture = load(sprite_texture)
		
	position = pos
	
	

func _process(delta: float) -> void:
	pass
	
