extends Node2D

# ---------------- VARIABLES ----------------
var in_the_cauldron: Array = []         # tracks ingredients in caudron
var brewed_potion: String = ""          # updates when ingredienst match a recipe
var ready_to_brew: bool = false         # when brewed_potion has string this is true
var is_paused: bool = false             # tracks paused
var in_settings: bool = false           # tracks when settings is opened

@onready var ingredient_sprites: Array = [
	$IngredientsAdded/Ingredient1,
	$IngredientsAdded/Ingredient2,
	$IngredientsAdded/Ingredient3
]

# ---------------- READY & PROCESS ----------------
func _ready() -> void:
	update_hud()
	$Settins.visible = in_settings              # hides settings
	$IngredientsAdded.visible = false           # hides 
	$Buttons/BrewBTN.disabled = true            # disables
	$ReadyToBrew/LoadingIcon.visible = false    # hides
	StateTracker.in_game = true                 # set state to in game
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):   # check fro pause input
		toggle_pause()

	# Reset brew readiness
	if not brewed_potion:      
		ready_to_brew = false

	# Update UI
	$ReadyToBrew.visible = ready_to_brew
	$IngredientsAdded.visible = in_the_cauldron.size() > 0
	update_hud()

func update_hud() -> void:
	$HUD/Level.text = str(PlayerStats.level)
	$HUD/xp.text = str(PlayerStats.xp)

# ---------------- INGREDIENT HANDLING ----------------
func add_ingredient_to_cauldron(ingredient) -> void:
	if in_the_cauldron.size() < ingredient_sprites.size():    # 3 max
		in_the_cauldron.append(ingredient.name_id)            # add to array
		brewed_potion = check_for_recipe()                    # checks if recipe matches
	else:
		play_burn()                                           # if 3 it burns ingredient

	update_ingredient_sprites()                               # give sprites textures
	update_brew_button()

func update_ingredient_sprites() -> void:
	# Fill slots
	for i in range(ingredient_sprites.size()):
		if i < in_the_cauldron.size():
			var ing = in_the_cauldron[i]
			ingredient_sprites[i].texture = load(GameData.ingredients_images[ing])
		else:
			ingredient_sprites[i].texture = null

func update_brew_button() -> void:
	if brewed_potion != "":
		print("Found key: ", brewed_potion)
		update_ready_to_brew_box(brewed_potion)
		$Buttons/BrewBTN.disabled = false
	else:
		print("no match")
		$Buttons/BrewBTN.disabled = true

func check_for_recipe() -> String:
	var copy_cauldron = in_the_cauldron.duplicate()
	copy_cauldron.sort()

	for key in GameData.potion_recipes:
		if GameData.potion_recipes[key] == copy_cauldron:
			ready_to_brew = true
			return key
	return ""

func update_ready_to_brew_box(key: String) -> void:	
	$ReadyToBrew/PotionSprite.texture = load(GameData.potion_images[key])
	$ReadyToBrew/PotionName.text = key

# ---------------- BREWING ----------------
func _on_brew_btn_pressed() -> void:
	$Buttons/BrewBTN.disabled = true
	
	if brewed_potion != "":
		await start_brewing()
		PlayerStats.add_potion(brewed_potion)
		PlayerStats.xp += PlayerStats.potion_made_xp
		brewed_potion = ""
	else:
		print("no brew")

	clear_cauldron()
	SaveManager.save_game(SaveManager.current_save_slot)

func start_brewing() -> void:
	$Miscellaneous/Bubbles.emitting = true       # start bubbling
	play_bubbling()                              # play bubbling sound
	$DropBox/CollisionShape2D.disabled = true    # disable drop box so no more can be added
	$ReadyToBrew/LoadingIcon.visible = true	     # start loadinf icon
	await get_tree().create_timer(2.0).timeout   # wait 2 second
	$DropBox/CollisionShape2D.disabled = false   # turn drop box back on	
	$ReadyToBrew/LoadingIcon.visible = false     # hide loading icon
	stop_bubbling()
	play_potion_made()

func clear_cauldron() -> void:
	in_the_cauldron.clear()
	update_ingredient_sprites()
	$IngredientsAdded.visible = false
	brewed_potion = ""

func _on_clear_pressed() -> void:
	clear_cauldron()
	$Buttons/BrewBTN.disabled = true

# ---------------- PAUSE ----------------
func toggle_pause() -> void:
	is_paused = !is_paused
	$PauseMenu.visible = is_paused

func _on_pause_menu_resume() -> void: toggle_pause()
func _on_user_btn_overlay_pause() -> void: toggle_pause()
func _on_pause_menu_main_menu() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

# ---------------- AUDIO HELPERS ----------------
func play_waterDrop(): $Sounds/WaterDrop.play()
func play_burn(): $Sounds/Burn.play()
func play_potion_made(): $Sounds/BottleUp.play()
func play_glass_break(): $Sounds/GlassBreak.play()
func play_bubbling(): $Sounds/Bubbling.play()
func stop_bubbling(): $Sounds/Bubbling.stop()


# --------------- SETTINGS ------------------------
func _on_pause_menu_settings() -> void:
	toggle_settings()

func toggle_settings():
	in_settings = not in_settings
	$Settins.visible = in_settings
	toggle_pause()

func _on_settins_back() -> void:
	
	toggle_settings()
	toggle_pause()
# ---------------- SIGNAL HANDLERS ----------------
func _on_leaf_ingredient_drop(ingredient: Variant) -> void:
	$Miscellaneous/splashParticles.position = ingredient.global_position + Vector2(0, 10)
	$Miscellaneous/splashParticles.emitting = true
	play_waterDrop()
	add_ingredient_to_cauldron(ingredient)

func _on_missed_body_entered(body: Node2D) -> void:
	body.position = StateTracker.get_position(body.name_id)
