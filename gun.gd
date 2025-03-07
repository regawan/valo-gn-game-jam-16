extends Area2D


signal shot
var can_shoot = true
const MAX_AMMO = 30
var ammo: int


func reload() -> void:
	ammo = MAX_AMMO


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()


func shoot() -> void:
	if ammo == 0:
		play_out_of_ammo_sound()
	else:
		const BULLET = preload("res://bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		play_shoot_sound()
		ammo = max(0, ammo - 1)
		shot.emit(ammo)

	can_shoot = false
	$ShotTimer.start()


func play_shoot_sound() -> void:
	var sfx = AudioStreamPlayer.new()
	sfx.stream = $ShotSound.stream
	sfx.volume_db = $ShotSound.volume_db
	sfx.pitch_scale = $ShotSound.pitch_scale
	sfx.connect("finished", sfx.queue_free)
	get_parent().add_child(sfx)
	sfx.play()


func play_out_of_ammo_sound() -> void:
	var sfx = AudioStreamPlayer.new()
	sfx.stream = $OutOfAmmoSound.stream
	sfx.volume_db = $OutOfAmmoSound.volume_db
	sfx.pitch_scale = $OutOfAmmoSound.pitch_scale
	sfx.connect("finished", sfx.queue_free)
	get_parent().add_child(sfx)
	sfx.play()


func _on_shot_timer_timeout() -> void:
	can_shoot = true
