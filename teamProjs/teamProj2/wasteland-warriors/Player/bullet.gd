extends Area2D
@export var speed = 750
var velocity = Vector2.ZERO

func start(_transform):
	transform = _transform
	velocity = transform.x * speed

func _process(delta):
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.die()
		queue_free()
	if body.is_in_group("boss"):
		body.apply_damage(1)
	if body.is_in_group("player"):
		body.die()
