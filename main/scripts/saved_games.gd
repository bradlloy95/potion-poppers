extends Node2D

@onready var nodes = {
	"save slot 1" : {
		"description":$SaveSlot1/Description1,
		"play button": $SaveSlot1/PlayBTN1,
		"delete button":$SaveSlot1/DeleteBTN1 },
	"save slot 2" : {
		"description":$SaveSlot2/Description2,
		"play button": $SaveSlot2/PlayBTN2,
		"delete button":$SaveSlot2/DeleteBTN2 },
	"save slot 3": {
		"description":$SaveSlot3/Description3,
		"play button": $SaveSlot3/PlayBTN3,
		"delete button":$SaveSlot3/DeleteBTN3 },
	}
	
var save_slot : String
var show_save_slots := true
var show_play_pop_up := false
var show_delete_pop_up := false
func _ready() -> void:
	for save in SaveManager.save_slots:
		var has_save = SaveManager.save_slots[save]["has save"]
		if not has_save:
			nodes[save]["description"].text = "No Saves Found"
			nodes[save]["play button"].text = "Start New Game"
			nodes[save]["delete button"].disabled = true
		else:
			var level = SaveManager.save_slots[save]["level"]
			var save_date = SaveManager.save_slots[save]["save date"]
			nodes[save]["description"].text = "Level: %s | Saved: %s" % [level, save_date]
			nodes[save]["play button"].text = "Start Game"
			nodes[save]["delete button"].disabled = false
			
		#print(save)
		#print(SaveManager.save_slots[save]["path"])
		#print(SaveManager.save_slots[save]["has save"])

func toggle_save_slots():
	show_save_slots = not show_save_slots
	$SaveSlot1.visible = show_save_slots
	$SaveSlot1.visible = show_save_slots
	$SaveSlot1.visible = show_save_slots
	
	$SaveSlot2.visible = show_save_slots
	$SaveSlot2.visible = show_save_slots
	$SaveSlot2.visible = show_save_slots
	
	$SaveSlot3.visible = show_save_slots
	$SaveSlot3.visible = show_save_slots
	$SaveSlot3.visible = show_save_slots

func toggle_play_pop_up():
	show_play_pop_up = not show_play_pop_up
	$StartGamePopUp.visible = show_play_pop_up 

func toggle_delete_pop_up():
	show_delete_pop_up = not show_delete_pop_up
	$DeletePopUp2.visible = show_delete_pop_up
# ---------------play pop up ---------------------------------
func _on_start_yes_button_pressed() -> void:
	SaveManager.load_game_save_slot(save_slot)
	get_tree().change_scene_to_file("res://main/scenes/BrewingScene.tscn")

func _on_start_no_button_2_pressed() -> void:
	toggle_save_slots()
	toggle_play_pop_up()
	
# -------------- delete pop up --------------------------
func _on_delete_yes_button_pressed() -> void:
	SaveManager.perm_delete_save(save_slot)
	_ready()
	toggle_delete_pop_up()
	toggle_save_slots()

func _on_delete_no_button_2_pressed() -> void:
	toggle_delete_pop_up()
	toggle_save_slots()


# ---------------- save slot 1 -------------------------------
func _on_play_btn_1_pressed() -> void:
	save_slot = "save slot 1"
	toggle_save_slots()
	toggle_play_pop_up()
	
func _on_delete_btn_1_pressed() -> void:
	save_slot = "save slot 1"
	toggle_save_slots()
	toggle_delete_pop_up()
	
	
# ------------------- save slot 2 -----------------------------
func _on_play_btn_2_pressed() -> void:
	save_slot = "save slot 2"
	toggle_save_slots()
	toggle_play_pop_up()

func _on_delete_btn_2_pressed() -> void:
	save_slot = "save slot 2"
	toggle_save_slots()
	toggle_delete_pop_up()

# ----------------------- save slot 3 ------------------------------
func _on_play_btn_3_pressed() -> void:
	save_slot = "save slot 3"
	toggle_save_slots()
	toggle_play_pop_up()

func _on_delete_btn_3_pressed() -> void:
	save_slot = "save slot 1"
	toggle_save_slots()
	toggle_delete_pop_up()

func _on_button_pressed() -> void:
	SaveManager.perm_delete_save_old(SaveManager.SAVE_FILE)
