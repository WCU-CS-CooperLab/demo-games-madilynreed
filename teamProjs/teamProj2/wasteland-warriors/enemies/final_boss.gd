extends CharacterBody2D

signal swipe
@export_file("*.tscn") var end_scene = "res://leaderboard/control.tscn"
@export var bullet_scene : PackedScene
@export var speed = 1500
@export var max_health = 10
@export var direction  = 0
@onready var health = max_health
@onready var animator = $AnimatedSprite2D
@export var bullet_spread = 0.2
var team_name = ""
var screensize = Vector2.ZERO
var _velocity = 0

func _ready() -> void:
	direction = Vector2(randf_range(-1, 2), randf_range(-1, 2)).normalized()
	$AnimatedSprite2D.play("Walk")

func start(_position):
	position = _position
	$AnimatedSprite2D.animation = "Idle"

func _process(delta):
	velocity = speed * delta * direction
	move_and_slide()
	if global_position.x > 900:
		global_position.x = 900
	elif global_position.x < 0:
		global_position.x = 0
	if global_position.y > 500:
		global_position.y = 500
	elif global_position.y < -1:
		global_position.y = 0

func apply_damage(damage):
	health -= damage
	if health < 1:
		rpc("die")
	elif health > 0:
		rpc("hit")
@rpc("authority","call_local")
func hit():
	$AnimatedSprite2D.play("Hurt")
	$hurtSound.play()
@rpc("authority","call_local")
func die():
	animator.play("Die")
	$deathSound.play()
	$AnimatedSprite2D.play("Die")
	queue_free()
	Global.uploadscore(team_name)
	get_tree().change_scene_to_file(end_scene)

	
@rpc("authority","call_local")
func shoot():
	speed = 0
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.rotation = $AnimatedSprite2D/Muzzle.rotation
	b.position = $AnimatedSprite2D/Muzzle.position
	b.start($AnimatedSprite2D/Muzzle.global_transform)
	$AnimatedSprite2D.play("Shoot")
	$gunSound.play()
	await get_tree().create_timer(1.0).timeout
	speed = 1500
	$AnimatedSprite2D.play("Walk")


func _on_gun_cooldown_timeout() -> void:
	rpc("shoot")


func _on_direction_timer_timeout() -> void:
	direction = Vector2(randf_range(-1, 2), randf_range(-1, 2)).normalized()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
	else:
		return
