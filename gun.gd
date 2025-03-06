extends Area2D

signal shot
var can_shoot = true


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()


func shoot() -> void:
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	shot.emit()
	can_shoot = false
	$ShotTimer.start()


func _on_shot_timer_timeout() -> void:
	can_shoot = true
