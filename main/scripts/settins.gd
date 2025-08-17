extends Control

func _ready() -> void:
	SettingsManager.load_settings()
	$PanelContainer/VBoxContainer/Volume.value = SettingsManager.volume
	$PanelContainer/VBoxContainer/Mute.button_pressed = SettingsManager.muted
	var idx = SettingsManager.resolution_sizes.find(SettingsManager.resolution)
	if idx == -1:
		idx = 3  # fallback to default (1152x648)
	$PanelContainer/VBoxContainer/OptionButton.selected = idx
	
func _on_volume_value_changed(value: float) -> void:
	SettingsManager.volume = value
	AudioServer.set_bus_volume_db(0, value/2)
	$PanelContainer/VBoxContainer/Volume.tooltip_text = str(int(value))


func _on_mute_toggled(toggled_on: bool) -> void:
	SettingsManager.muted = toggled_on
	AudioServer.set_bus_mute(0, toggled_on)


func _on_menu_btn_pressed() -> void:
	SettingsManager.save_settings()
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")


func _on_reset_pressed() -> void:
	
	SettingsManager.perm_delete_settings()
	
	
	$PanelContainer/VBoxContainer/Volume.value = SettingsManager.volume
	$PanelContainer/VBoxContainer/Mute.button_pressed = SettingsManager.muted
	$PanelContainer/VBoxContainer/OptionButton.select(3)


func _on_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(SettingsManager.resolution_sizes[index])
	SettingsManager.resolution = SettingsManager.resolution_sizes[index]
	SettingsManager.save_settings()
	
