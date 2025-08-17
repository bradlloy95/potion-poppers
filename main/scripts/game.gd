extends Node2D

# --- Game State Variables ---
var is_paused = false                  # Pause state
var is_gameOver = false                # Game over state
var recipe                             # Current recipe list (ingredients still needed)
var random_potion: String              # Current potion name
var score := 0                         # Player's score
var added_ingredients = []             # Ingredients already dropped in
var time_dampener : float = 0.1        # Reduces countdown timer by 0.1s each successful brew


# --- Lifecycle ---
func _ready() -> void:
	# Setup UI
	$PauseMenu.visible = is_paused
	$Gamover.visible = is_gameOver
	
	# Reset player lives
	GameData.lives = 3
	
	# Select first recipe
	get_random_recipe()
	
	# Initialize HUD
	$GameGraphics/HUD/Score.text = "Score " + str(score)
	$GameGraphics/HUD/CountDown.text = str($CountdownTimer.wait_time)
	$CountdownTimer.start()


func _physics_process(_delta: float) -> void:
	# Skip game logic if over
	if not is_gameOver:
		# Update HUD
		$GameGraphics/HUD/CountDown.text = String.num($CountdownTimer.time_left, 1)
		$GameGraphics/HUD/Score.text = str(score)
		update_recipe()
		
		# Pause toggle
		if Input.is_action_just_pressed("pause"):
			toggle_pause()
		
		# Game over check
		if GameData.lives < 1:
			is_gameOver = true
		
		# Potion complete
		if recipe.size() == 0:
			score += 1
			play_potion_made()
			GameData.brewed_potions[random_potion] += 1
			get_random_recipe()
			
			# Speed up game (reduce available time)
			$CountdownTimer.wait_time -= time_dampener
	else:
		# Handle game over once triggered
		gameover()


# --- Audio Helpers ---
func play_waterDrop():
	$Sounds/WaterDrop.play()

func play_burn():
	$Sounds/Burn.play()

func play_potion_made():
	$Sounds/BottleUp.play()

func play_glass_break():
	$Sounds/GlassBreak.play()


# --- Pause Handling ---
func toggle_pause():
	is_paused = not is_paused
	
	# Show/hide UI groups
	$GameGraphics/HUD.visible = not is_paused
	$GameGraphics.visible = not is_paused
	$PauseMenu.visible = is_paused
	
	# Stop/resume timer
	$CountdownTimer.set_paused(is_paused)



# --- Game Over ---
var has_gameover_run := false  # NEW FLAG

func gameover():
	if has_gameover_run:
		return
	has_gameover_run = true

	# Freeze gameplay
	$CountdownTimer.stop()
	$GameGraphics/HUD.visible = false
	$GameGraphics.visible = false
	$Artwork.visible = false
	$Gamover.visible = true
	$Sounds/background.stop()
	
	# Update score + high score
	if score > GameData.high_score:
		GameData.high_score = score
		$Gamover/Message.text = "New High Score!"
		$Gamover/FinalScore.text = "final score: " + str(score)
		print("NEW High Score:", score)
	else:
		$Gamover/Message.text = "Game Over"
		$Gamover/FinalScore.text = "final score: " + str(score)

	# Save progress immediately
	SaveManager.save_game()



# --- Recipe Handling ---
func check_recipe(ingredient):
	# If ingredient is correct
	if ingredient in recipe:
		if recipe.size() != 1:
			play_waterDrop()
		recipe.erase(ingredient)
		added_ingredients.append(ingredient)
	else:
		# Wrong ingredient
		play_burn()
		get_random_recipe()
		GameData.lives -= 1


func update_recipe():
	var recipe_str = ""

	# Show current required ingredients
	for item in recipe:
		recipe_str += item + "\n"

	# Show already added ingredients as strikethrough
	for item in added_ingredients:
		recipe_str += "[s]" + item + "[/s]" + "\n"

	$GameGraphics/HUD/Recipe.text = recipe_str


func get_random_recipe():
	# Pick a random potion
	var last_potion
	# dont repeat same potion 
	if random_potion:
		last_potion = random_potion
	random_potion = GameData.potions[randi() % GameData.potions.size()]
	recipe = GameData.potion_recipes[random_potion].duplicate(true)
	if random_potion == last_potion:
		print("repeated potion")
		get_random_recipe()
	# Update UI
	$GameGraphics/HUD/Potion.text = random_potion
	added_ingredients.clear()
	update_recipe()
	$CountdownTimer.start()


# --- Timer Handling ---
func _on_timer_timeout() -> void:
	# Lose life if timer runs out
	GameData.lives -= 1
	get_random_recipe()
	play_glass_break()
	$CountdownTimer.start()


# --- Ingredient Drop ---
func _on_artwork_ingredient_drop(ingredient: Variant) -> void:
	check_recipe(ingredient.name_id)



# --- UI Buttons ---
# Pause Menu
func _on_pause_button_pause_pressed() -> void:
	toggle_pause()

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")

# Game Over Menu
func _on_game_over_menu_btn_pressed() -> void:
	# Save progress
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")




func _on_pause_button_pressed() -> void:
	toggle_pause()
