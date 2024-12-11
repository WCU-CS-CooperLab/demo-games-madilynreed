extends Area2D
@export var speed = 650
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
		pass
	if body.is_in_group("boss"):
		pass
	if body.is_in_group("player"):
		body.die()
