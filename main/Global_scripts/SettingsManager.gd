extends Node

func _ready() -> void:
	load_settings()
	
const SETTINGS_SAVE_FILE := "user://settings.json"

var muted : bool = false
var volume : float = 0.0
var volume_slider : float = 0.0
var resolution : Vector2i = Vector2i(1152, 648)
var fullscreen : bool = false


var resolution_sizes = [
	Vector2i(1920,1080),
	Vector2i(1600,900),
	Vector2i(1280,720),
	Vector2i(1152,648)
]

func set_defaul_settings():
	muted = false
	volume = 0.0
	volume_slider = 0.0
	resolution = Vector2i(1152, 648)
	fullscreen = false
	
func save_settings():
	var data = {
		"muted": muted,
		"volume": volume,
		"volume slider": volume_slider,
		"resolution": [resolution.x, resolution.y],
		"fullscreen": fullscreen
	}
	var file = FileAccess.open(SETTINGS_SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Settings saved")

func load_settings():
	if not FileAccess.file_exists(SETTINGS_SAVE_FILE):
		print("No settings file found. Using defaults.")
		set_defaul_settings()
		save_settings()
		return
	
	var file = FileAccess.open(SETTINGS_SAVE_FILE, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if typeof(result) == TYPE_DICTIONARY:
			volume = float(result.get("volume", 0.0))
			muted = bool(result.get("muted"))
			
			volume_slider = float(result.get("volume slider", 0.0))
			
			var res = result.get("resolution", [1152,648])
			resolution = Vector2i(res[0], res[1])
			
			fullscreen = bool(result.get("fullscreen", false))
		file.close()
	
	
	# Apply immediately
	AudioServer.set_bus_volume_db(0, volume/2)
	AudioServer.set_bus_mute(0, muted)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)

func perm_delete_settings():
	var dir = DirAccess.open("user://")
	if dir.file_exists(SETTINGS_SAVE_FILE):
		dir.remove(SETTINGS_SAVE_FILE)
		print("Settings reset.")
	load_settings()
