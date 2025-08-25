extends TextureButton

@export var expand_BTN : Texture2D
@export var minimise_BTN : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_button_state()


func _on_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(SettingsManager.resolution)
		SettingsManager.fullscreen = false
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		SettingsManager.fullscreen = true
		SettingsManager.save_settings()

	_update_button_state()


func _on_mouse_entered() -> void:
	scale *= 1.05


func _on_mouse_exited() -> void:
	scale /= 1.05


func _update_button_state() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		texture_normal = minimise_BTN
		tooltip_text = "Minimize"
	else:
		texture_normal = expand_BTN
		tooltip_text = "Full Screen"
