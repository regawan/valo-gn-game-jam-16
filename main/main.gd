extends Node


@export var mob_scene: PackedScene
var ammoCounter: int


func _ready():
	pass


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
	$Player.start($StartPosition.position)
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
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Set the spawn location to a random position on Path.
	%MobSpawnLocation.progress_ratio = randf()
	mob.global_position = %MobSpawnLocation.global_position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_player_gun_shot(arg) -> void:
	ammoCounter = arg
	# Update ammo in HUD
	$HUD.update_ammo(ammoCounter)
