extends Area2D

var travelled_distance = 0
const SPEED = 1000
const RANGE = 300


func _physics_process(delta:float):
	var direction =  Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

	$Tracer.texture_scale = max(0, 1.0 - travelled_distance / RANGE)
	$Tracer.energy = max(0.1, 1.0 - travelled_distance / RANGE)


func _on_body_entered(body:Node2D):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
