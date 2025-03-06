extends Area2D

signal shot

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func shoot() -> void:
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	shot.emit()


func _on_timer_timeout() -> void:
	shoot()
