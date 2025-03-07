extends CharacterBody2D

signal health_depleted
signal gun_shot

@export var speed = 80 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
const MAX_HEALTH = 100.0
var health = 100.0
const DAMAGE_RATE = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Reset the player when starting a new game
func start():
	health = MAX_HEALTH
	%ProgressBar.value = health
	$Gun.reload()
	set_physics_process(true)
	$Gun.set_physics_process(true)
	show()
	$CollisionShape2D.set_deferred("disabled", false)

func die():
	set_physics_process(false)
	$Gun.set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO

	# Input control
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Check if moving
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		if $WalkSound.playing == false:
			$WalkSound.play()
	else:
		$AnimatedSprite2D.stop()

	# Move player
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# Animation control
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "walk_up"
		else:
			$AnimatedSprite2D.animation = "walk_down"
		$AnimatedSprite2D.flip_v = false

	# Health management
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * delta * overlapping_mobs.size()
		%ProgressBar.value = health
		%ProgressBar.max_value = 100
		if health <= 0.0:
			health_depleted.emit()
			$CollisionShape2D.set_deferred("disabled", true)


func _on_gun_shot(arg) -> void:
	gun_shot.emit(arg)
