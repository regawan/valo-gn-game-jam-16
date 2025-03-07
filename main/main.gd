extends Node


@export var mob_scene: PackedScene
var ammoCounter: int
var level = 0
var mob_spawn_count: int
var mobs_to_kill: int
var modulate_color: Color

func _ready():
	pass


func level_manager():
	if level == 0:
		mob_spawn_count = 3
		mobs_to_kill = 3
		modulate_color = Color(255, 255, 255, 255)
	elif level == 1:
		mob_spawn_count = 5
		mobs_to_kill = 5
		var steps = 300
		for i in range(steps+1):
			if i % 30 == 0:
				$CanvasModulate.color = Color(1.0 - (float(i) / float(steps)), 1.0 - (float(i) / float(steps)), 1.0 - (float(i) / float(steps)), 1.0)
			await get_tree().process_frame
	elif level == 2:
		mob_spawn_count = 10
		mobs_to_kill = 10
	elif level == 3:
		mob_spawn_count = 15
		mobs_to_kill = 15
	elif level == 4:
		mob_spawn_count = 20
		mobs_to_kill = 20
	elif level == 5:
		mob_spawn_count = 25
		mobs_to_kill = 25


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
	level_manager()
	$Player.start()
	ammoCounter = $Player/Gun.ammo
	$StartTimer.start()
	# Update and show HUD
	$HUD.update_ammo(ammoCounter)
	$HUD.show_message("Get Ready")
	# Remove mobs when new game starts
	get_tree().call_group("mobs", "queue_free")
	# Music start
	$Music.play()


func _on_start_timer_timeout():
	$MobTimer.start()


func _on_mob_timer_timeout():
	if mob_spawn_count > 0:
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
		mob_spawn_count = max(0, mob_spawn_count - 1)


func _on_player_gun_shot(arg) -> void:
	ammoCounter = arg
	# Update ammo in HUD
	$HUD.update_ammo(ammoCounter)

func _on_mob_died():
	mobs_to_kill = max(0, mobs_to_kill - 1)
	if mobs_to_kill == 0:
		level += 1
		new_game()
		
