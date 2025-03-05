extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	# Show game over text
	$HUD.show_game_over()
	# Music end
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# Update and show HUD
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# Remove mobs when new game starts
	get_tree().call_group("mobs", "queue_free")
	# Music start
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	# Update score in HUD
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Set the spawn location to a random position on Path.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

