extends Node2D

var is_paused = false
var is_gameOver = false

var recipe
var random_item
var lives := 3
var score := 0

func _ready() -> void:
	$PauseMenu.visible = is_paused
	get_random_recipe()
	
	# set up HUD
	
	$HUD/lives.text = "Lives " + str(lives)
	$HUD/Score.text = "Score " + str(score)
	$HUD/CountDown.text = str($CountdownTimer.wait_time)
	$CountdownTimer.start()
	$Gamover.visible = is_gameOver
	
	
func _physics_process(_delta: float) -> void:
	
	if  not is_gameOver:
		$HUD/CountDown.text = str($CountdownTimer.time_left)
		$HUD/Score.text = "Score " + str(score)
		# listen for pause button to be pressed
		if Input.is_action_just_pressed("pause"):
			if not is_paused:
				
				is_paused = true
				# hide gameHUD
				$HUD.visible = not is_paused
				$Artwork.visible = not is_paused
				# Show pause menu
				$PauseMenu.visible = is_paused
				# pause timer
				$CountdownTimer.set_paused(is_paused)				
			else:
				is_paused = false
				$HUD.visible = not is_paused
				$Artwork.visible = not is_paused
				$PauseMenu.visible = is_paused
				# restarr timer
				$CountdownTimer.set_paused(is_paused)
			
		if lives < 1:
			is_gameOver = true
			
		if recipe.size() == 0:
			score += 1
			get_random_recipe()
		
	else:
		gameover()
	
		

func play_waterDrop():
	$WaterDrop.play()

func gameover():
	$CountdownTimer.stop()
	$HUD.visible = false
	$Artwork.visible = false
	$Gamover.visible = is_gameOver
	$Gamover/FinalScore.text = "Final Score: " + str(score)
	
func check_recipe(ingredient):
	
	if ingredient in recipe:
		play_waterDrop()
		recipe.erase(ingredient)
		# make correct noise
		
	else:
		lives -= 1
		$HUD/lives.text = "Lives " + str(lives)
		# make error noise

func get_random_recipe():
	# get ramdom potion 
	random_item = Global.postions[randi() % Global.postions.size()]
	# get the potions recipe
	recipe = Global.postion_recipes[random_item].duplicate(true)
	$HUD/Potion.text = random_item
	var recipe_str = ""
	for item in recipe:
		recipe_str  = recipe_str  + item + "\n"
	print(random_item)
	$HUD/Recipe.text = recipe_str
	$CountdownTimer.start()



func _on_resume_button_pressed() -> void:
	is_paused = false
	$HUD.visible = not is_paused
	$Artwork.visible = not is_paused
	$PauseMenu.visible = is_paused
	# restart timer
	$CountdownTimer.set_paused(is_paused)


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")


func _on_timer_timeout() -> void:
	print("time out")
	lives -= 1
	$HUD/lives.text = "Lives " + str(lives)
	#play timeout sound
	$CountdownTimer.start()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/scenes/start_menu.tscn")


func _on_artwork_leaf_drop() -> void:
	check_recipe("Leaf")
	


func _on_artwork_slime_drop() -> void:
	check_recipe("Slime")
	

func _on_artwork_mushroom_drop() -> void:
	check_recipe("Mushroom")


func _on_artwork_ember_drop() -> void:
	check_recipe("Ember Root")


func _on_artwork_crystal_drop() -> void:
	check_recipe("Crystal Berry")





func _on_artwork_ingredient_drop(ingredient: Variant) -> void:
	check_recipe(ingredient.name_id)
