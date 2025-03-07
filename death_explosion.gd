extends CPUParticles2D

func _ready() -> void:
    emitting = true
    $DeathLight.energy = 1.0

func _process(_delta: float) -> void:
    $DeathLight.energy = max(0.0, $DeathLight.energy - 0.02)

func _on_finished() -> void:
    queue_free()

