extends Area2D

@export var health_boost = 20 # change based on total player health



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.increase_health(health_boost)
		queue_free()
