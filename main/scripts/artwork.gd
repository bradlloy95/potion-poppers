extends Node2D


func _ready() -> void:
	SaveManager.load_game()
	$HUD/Level.text = str(PlayerStats.level)
	$HUD/xp.text = str(PlayerStats.xp)
	$IngredientsAdded.visible = false
	$Buttons/BrewBTN.disabled = true
	$ReadyToBrew/LoadingIcon.visible = false
func _process(delta: float) -> void:
	# Pause toggle
	if Input.is_action_just_pressed("pause"):
			toggle_pause()

# ~~ check for potion to be brewed ~~~~~~
	if not brewed_potion:
		ready_to_brew = false
	
	
	
	$ReadyToBrew.visible = ready_to_brew
	
	if in_the_cauldron.size() > 0:
		$IngredientsAdded.visible = true

# ~~ update HUD ~~
	$HUD/xp.text = str(PlayerStats.xp)
	$HUD/Level.text = str(PlayerStats.level)



func _on_leaf_ingredient_drop(ingredient: Variant) -> void:
	$Miscellaneous/splashParticles.position = ingredient.global_position
	$Miscellaneous/splashParticles.position.y += 10
	$Miscellaneous/splashParticles.emitting = true
	play_waterDrop()
	add_ingredient_to_cauldron(ingredient)
	
func _on_missed_body_entered(body: Node2D) -> void:
	body.position = StateTracker.get_position(body.name_id)
	

# --- Audio Helpers ---
func play_waterDrop():
	$Sounds/WaterDrop.play()
func play_burn():
	$Sounds/Burn.play()
func play_potion_made():
	$Sounds/BottleUp.play()
func play_glass_break():
	$Sounds/GlassBreak.play()
func play_bubbling():
	$Sounds/Bubbling.play()
func stop_bubbling():
	$Sounds/Bubbling.stop()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# -- pasue menu --
var is_paused := false

func toggle_pause():
	is_paused = not is_paused
	$PauseMenu.visible = is_paused

func _on_pause_menu_resume() -> void:
	toggle_pause()

func _on_user_btn_overlay_pause() -> void:
	toggle_pause()

func _on_pause_menu_main_menu() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# -- brewing logic --

var in_the_cauldron = []
var brewed_potion
var ready_to_brew = false

@onready var ingredient_sprites = [
	$IngredientsAdded/Ingredient1,
	$IngredientsAdded/Ingredient2,
	$IngredientsAdded/Ingredient3
]

func add_ingredient_to_cauldron(ingredient):
	# restrict size of cauldron to 3 ingredients
	if in_the_cauldron.size() < 3:
		in_the_cauldron.append(ingredient.name_id)	
		brewed_potion = check_for_recipe()
		
	elif in_the_cauldron.size() >= 3:
		play_burn()
		print("too many ingredients")
	
	# Update sprites
	for i in range(in_the_cauldron.size()):
		var ing = in_the_cauldron[i]
		var sprite = ingredient_sprites[i]
		var image_path = GameData.ingredients_images[ing]
		sprite.texture = load(image_path)
	
	if brewed_potion != "":
		print("Found key: ", brewed_potion)
		update_ready_to_brew_box(brewed_potion)
		$Buttons/BrewBTN.disabled = false
	else:
		$Buttons/BrewBTN.disabled = true
		print("no match")

func check_for_recipe():
	for key in GameData.potion_recipes:
		var copy_cauldron = in_the_cauldron.duplicate()
		copy_cauldron.sort()

		if GameData.potion_recipes[key] == copy_cauldron:
			ready_to_brew = true
			return key
			
	return ""

func update_ready_to_brew_box(key):	
	$ReadyToBrew/PotionSprite.texture = load(GameData.potion_images[key])
	$ReadyToBrew/PotionName.text = key

func _on_brew_btn_pressed() -> void:
	$Buttons/BrewBTN.disabled = true
	if brewed_potion:
		$Miscellaneous/Bubbles.emitting = true      # Creates more bubbles
		play_bubbling()                             # play bubbling sound
		$ReadyToBrew/LoadingIcon.visible = true
		# wait 2 seconds
		await get_tree().create_timer(2.0).timeout 
		$ReadyToBrew/LoadingIcon.visible = false
		stop_bubbling()                             # stop bubbling sound
		play_potion_made()                          # audio confirmation of potion made
		PlayerStats.add_potion(brewed_potion)
		PlayerStats.xp += PlayerStats.potion_made_xp
		brewed_potion = null
	else:
		print("no brew")		
	
	# clear array
	in_the_cauldron.clear()
	for sprite in ingredient_sprites:
		sprite.texture = null
	$IngredientsAdded.visible = false
	
	
	


func _on_clear_pressed() -> void:
	$Buttons/BrewBTN.disabled = true
	in_the_cauldron.clear()
	for sprite in ingredient_sprites:
		sprite.texture = null
	$IngredientsAdded.visible = false
	brewed_potion = null
	
