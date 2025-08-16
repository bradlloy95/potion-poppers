extends Node2D

# Game state variables
var is_paused = false
var is_gameOver = false
var recipe                       # The current recipe list
var random_potion: String                # The current potion name
var score := 0
var added_ingredients = []       # Ingredients the player has added
var time_dampener : float = 0.1  # reduce time by 0.1 seconds every time coreect

func _ready() -> void:
	# Initialize game state and UI
	$PauseMenu.visible = is_paused
	$Gamover.visible = is_gameOver
	Global.lives = 3
	
	get_random_recipe()
	
	# Set up HUD
	$GameGraphics/HUD/Score.text = "Score " + str(score)
	$GameGraphics/HUD/CountDown.text = str($CountdownTimer.wait_time)
	$CountdownTimer.start()


func _physics_process(_delta: float) -> void:
	# Only update if game is not over
	if not is_gameOver:
		# Update countdown and score display
		$GameGraphics/HUD/CountDown.text = String.num($CountdownTimer.time_left,1)
		$GameGraphics/HUD/Score.text =str(score)
		
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
			Global.potions_brewed[random_potion] += 1
			get_random_recipe()
			# make timer less time
			$CountdownTimer.wait_time -= 0.1
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
	
	## hide or show non pause menu items
	$GameGraphics/HUD.visible = not is_paused
	$GameGraphics.visible = not is_paused
	# hide or show pause menu items
	$PauseMenu.visible = is_paused	
	$CountdownTimer.set_paused(is_paused)


# Handle game over state
func gameover():
	$CountdownTimer.stop()
	$GameGraphics/HUD.visible = false
	$GameGraphics.visible = false
	$Artwork.visible = false
	$Gamover.visible = true
	# check for high score
	if score > Global.highest_score:
		print("HIGH score")
		Global.highest_score = score
		$Gamover/FinalScore.text = "final score: " + str(score) + "New High Score!"
	else:
		$Gamover/FinalScore.text = "final score: " + str(score) 
	$Sounds/background.stop()
	Global.save_game()
	


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

	$GameGraphics/HUD/Recipe.text = recipe_str


# Selects a new random potion and its recipe
func get_random_recipe():
	random_potion = Global.postions[randi() % Global.postions.size()]
	recipe = Global.postion_recipes[random_potion].duplicate(true)

	$GameGraphics/HUD/Potion.text = random_potion
	added_ingredients.clear()
	update_recipe()
	$CountdownTimer.start()

# Pause menu resume button

# Pause menu quit button
func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

# Called when countdown timer runs out
func _on_timer_timeout() -> void:
	Global.lives -= 1
	get_random_recipe()
	play_glass_break()
	$CountdownTimer.start()


# Generic ingredient drop (for dynamic/custom ingredients)
func _on_artwork_ingredient_drop(ingredient: Variant) -> void:
	check_recipe(ingredient.name_id)
	print(ingredient.name_id + " has entered the cauldron")


func _on_pause_button_pause_pressed() -> void:
	toggle_pause()

# Pause menu resume button
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")
	
# Game over menu main menu button
func _on_game_over_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")
