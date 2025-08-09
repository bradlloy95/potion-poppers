extends Node2D

# Game state variables
var is_paused = false
var is_gameOver = false
var recipe                       # The current recipe list
var random_item                  # The current potion name
var score := 0
var added_ingredients = []       # Ingredients the player has added

func _ready() -> void:
	# Initialize game state and UI
	$PauseMenu.visible = is_paused
	$Gamover.visible = is_gameOver
	
	get_random_recipe()
	
	# Set up HUD
	$HUD/Score.text = "Score " + str(score)
	$HUD/CountDown.text = str($CountdownTimer.wait_time)
	$CountdownTimer.start()


func _physics_process(_delta: float) -> void:
	# Only update if game is not over
	if not is_gameOver:
		# Update countdown and score display
		$HUD/CountDown.text = str($CountdownTimer.time_left)
		$HUD/Score.text = "Score " + str(score)
		
		update_recipe()  # Refresh recipe display

		# Handle pause input
		if Input.is_action_just_pressed("pause"):
			toggle_pause()
		
		# Check for game over condition
		if Global.lives < 1:
			is_gameOver = true
		
		# Check if recipe is completed
		if recipe.size() == 0:
			score += 1
			play_potion_made()
			get_random_recipe()
	else:
		gameover()


# Audio helper functions
func play_waterDrop():
	$Sounds/WaterDrop.play()

func play_burn():
	$Sounds/Burn.play()

func play_potion_made():
	$Sounds/BottleUp.play()

func play_glass_break():
	$Sounds/GlassBreak.play()


# Toggle pause state
func toggle_pause():
	# change pause state
	is_paused = not is_paused
	
	# hide or show non pause menu items
	$HUD.visible = not is_paused
	#$Artwork.visible = not is_paused
	$PauseButton.visible = not is_paused
	
	# hide or show pause menu items
	$PauseMenu.visible = is_paused	
	$CountdownTimer.set_paused(is_paused)


# Handle game over state
func gameover():
	$CountdownTimer.stop()
	$HUD.visible = false
	$Artwork.visible = false
	$Gamover.visible = true
	$Gamover/FinalScore.text = "Final Score: " + str(score)
	$Sounds/background.stop()


# Called when an ingredient is dropped into the cauldron
func check_recipe(ingredient):
	if ingredient in recipe:
		if recipe.size() != 1:
			play_waterDrop()
		recipe.erase(ingredient)
		added_ingredients.append(ingredient)
	else:
		play_burn()
		get_random_recipe()
		Global.lives -= 1


# Updates the recipe display on the HUD
func update_recipe():
	var recipe_str = ""

	# Show current required ingredients
	for item in recipe:
		recipe_str += item + "\n"

	# Show already added ingredients as strikethrough
	if added_ingredients:
		for item in added_ingredients:
			recipe_str += "[s]" + item + "[/s]"

	$HUD/Recipe.text = recipe_str


# Selects a new random potion and its recipe
func get_random_recipe():
	random_item = Global.postions[randi() % Global.postions.size()]
	recipe = Global.postion_recipes[random_item].duplicate(true)

	$HUD/Potion.text = random_item
	added_ingredients.clear()
	update_recipe()
	$CountdownTimer.start()

# Pause menu resume button
func _on_resume_button_pressed() -> void:
	toggle_pause()

# Pause menu quit button
func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

# Called when countdown timer runs out
func _on_timer_timeout() -> void:
	Global.lives -= 1
	get_random_recipe()
	play_glass_break()
	$CountdownTimer.start()

# Game over menu main menu button
func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

# Generic ingredient drop (for dynamic/custom ingredients)
func _on_artwork_ingredient_drop(ingredient: Variant) -> void:
	check_recipe(ingredient.name_id)
	print(ingredient.name_id + " has entered the cauldron")


func _on_pause_button_pause_pressed() -> void:
	toggle_pause()
