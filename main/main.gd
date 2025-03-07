extends Node


@export var mob_scene: PackedScene
var ammoCounter: int
var level = 0
var total_mobs: int
var mobs_to_spawn: int
var mobs_to_kill: int
var modulate_color: Color
var game_completed = false


func _ready():
	$Music.play()
	$AmbientSound.play()


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("restart_level"):
			new_game()
		elif event.is_action_pressed("quit"):
			get_tree().quit()


func level_manager():
	if level == 0:
		total_mobs = 3
		modulate_color = Color(255, 255, 255, 255)
	elif level == 1:
		total_mobs = 5
		fade_canvas_modulate(1.0)
	elif level == 2:
		total_mobs = 10
	elif level == 3:
		total_mobs = 15
	elif level == 4:
		total_mobs = 20
	elif level == 5:
		total_mobs = 25


func game_over():
	get_tree().call_group("mobs", "set_physics_process(false)")
	$Player.die()
	$MobTimer.stop()

	# Show game over text
	$HUD.show_game_over()

	# Music end
	$Music.stop()
	$DeathSound.play()


func new_game():
	# Remove mobs when new game starts
	get_tree().call_group("mobs", "queue_free")
	
	$HUD/MessageTimer.start()

	level_manager()

	$Player.start()

	if level == 0:
		$HUD.show_message("Welcome to Valo!")
		await $HUD/MessageTimer.timeout
		$HUD.show_message("Use WASD to move, mouse to aim, left click to fire!")
		await $HUD/MessageTimer.timeout
		$HUD.show_message("Survive.")
	elif level == 1:
		$HUD.show_message("What is happening?! The world is going dark!")
		await $HUD/MessageTimer.timeout
		$HUD.show_message("Suddenly, you hear much clearer. Are those footsteps?!")
		await $HUD/MessageTimer.timeout
		$HUD.show_message("But how can you view where they are coming from?")
		await $HUD/MessageTimer.timeout
		$HUD.show_next_level(total_mobs, level)
	else:
		$HUD.show_message("Fumbling in the darkness, you find a magazine of bullets.")
		await $HUD/MessageTimer.timeout
		$HUD.show_next_level(total_mobs, level)
	
	mobs_to_kill = total_mobs
	mobs_to_spawn = total_mobs
	ammoCounter = $Player/Gun.ammo
	$MobTimer.start()

	# Update and show HUD
	$HUD.update_level_indicator(level)
	$HUD.update_mob_counter(mobs_to_kill, total_mobs)
	$HUD.update_ammo(ammoCounter)

	

func fade_canvas_modulate(direction: float):
	var steps = 300
	for i in range(steps+1):
		var factor = float(i) / float(steps)
		if direction == 1.0:
			factor = 1.0 - factor
		if i % 20 == 0:
			$CanvasModulate.color = Color(factor, factor, factor, 1.0)
		await get_tree().process_frame


func _on_mob_timer_timeout():
	if mobs_to_spawn > 0:
		# Create a new instance of the Mob scene.
		var mob = mob_scene.instantiate()

		# Set the spawn location to a random position on Path.
		%MobSpawnLocation.progress_ratio = randf()
		mob.global_position = %MobSpawnLocation.global_position

		# Connect the mob's "died" signal to a function in this script.
		mob.exploding.connect(_on_mob_died)

		# Spawn the mob by adding it to the Main scene.
		add_child(mob)

		# Decrease the mob count.
		mobs_to_spawn = max(0, mobs_to_spawn - 1)
	else:
		$MobTimer.stop()


func _on_player_gun_shot(arg) -> void:
	ammoCounter = arg

	# Update ammo in HUD
	$HUD.update_ammo(ammoCounter)


func _on_mob_died():
	mobs_to_kill = max(0, mobs_to_kill - 1)
	if mobs_to_kill == 0:
		level += 1
		if level == 6:
			fade_canvas_modulate(0.0)
			$HUD.show_message("You have survived the darkness.")
			await $HUD/MessageTimer.timeout
			$HUD.show_message("But for how long?")
			await $HUD/MessageTimer.timeout
			$HUD.show_message("Thank you for playing Valo! My first game!")
		else:
			new_game()

	# Update HUD
	$HUD.update_mob_counter(mobs_to_kill, total_mobs)
		
