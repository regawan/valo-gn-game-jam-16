extends CPUParticles2D


func _ready() -> void:
    emitting = true
    $DeathLight.energy = 1.0
    $ExplosionSound.play()


func _process(_delta: float) -> void:
    $DeathLight.energy = max(0.0, $DeathLight.energy - 0.02)


func _on_explosion_sound_finished() -> void:
    queue_free()
