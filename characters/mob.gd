extends CharacterBody2D

@export var speed = 20 # How fast the mob will move (pixels/sec).
var player
signal exploding

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Main/Player")
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$WalkSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0


func take_damage():
	exploding.emit()
	queue_free()

	# Make it explode
	const EXPLOSION_SCENE = preload("res://death_explosion.tscn")
	var explosion = EXPLOSION_SCENE.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

	
