extends CharacterBody2D

@export var run_speed = 125
@export var direction = Vector2.ZERO

signal attack

var screensize = Vector2.ZERO

var _velocity = 0

func _ready() -> void:
	pass

func start(_position):
	position = _position
	$AnimatedSprite2D.animation = "cyborgIdle"

func _process(delta):
	velocity = direction * run_speed
	move_and_slide()
	if global_position.x > 1100:
		global_position.x = 1100
	elif global_position.x < 0:
		global_position.x = 0
	if global_position.y > 600:
		global_position.y = 600
	elif global_position.y < -1:
		global_position.y = 0
	

func die():
	$ShutDown.play()
	$AnimatedSprite2D.play("cyborgDeath")
	run_speed = 0
	await $AnimatedSprite2D.animation_finished
	queue_free()



func _on_timer_timeout() -> void:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("cyborgRun")
		run_speed = 150
		direction = Vector2(randf_range(-1, 2), randf_range(-1, 2)).normalized()
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = 1
		else:
			$AnimatedSprite2D.flip_h = 0
		velocity = direction * run_speed
		move_and_slide()


@rpc("authority","call_local")
func hit():
	run_speed = 0
	$AnimatedSprite2D.play("cyborgAttack1")


func _on_stop_timer_timeout() -> void:
	$AnimatedSprite2D.stop()
	run_speed = 0
	$AnimatedSprite2D.play("cyborgIdle")
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
	else:
		return
