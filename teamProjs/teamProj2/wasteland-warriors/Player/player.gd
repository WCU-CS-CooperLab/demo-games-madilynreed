extends CharacterBody2D

signal died
signal pickup

@export var speed = 500
@export var direction = 0
@export var bullet_scene : PackedScene
@export var fire_rate = 0.25
var can_shoot = true

var resources_collected = 0
var focused = false
@onready var animated_sprites = $AnimatedSprite2D

enum{INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT

@rpc("any_peer", "call_local")
func setup_multiplayer(player_id):
	set_multiplayer_authority(player_id)
	var is_player = str(player_id) == str(name)
	set_physics_process(is_player)
	set_process_unhandled_input(is_player)
	

func _ready():
	change_state(ALIVE)
	$GunCooldown.wait_time = fire_rate

func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.set_deferred("disabled", true)
		ALIVE:
			$CollisionShape2D.set_deferred("disabled", false)
		INVULNERABLE:
			$CollisionShape2D.set_deferred("disabled", true)
		DEAD:
			$CollisionShape2D.set_deferred("disabled", true)
	state = new_state

func _process(delta):
	velocity = Input.get_vector("run_left", "run_right", "run_up", "run_down")
	position.x += velocity.x * speed * delta
	position.y += velocity.y * speed * delta
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if state == INVULNERABLE:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.rotation = $AnimatedSprite2D/Gun.rotation
	b.position = $AnimatedSprite2D/Gun.position
	b.start($AnimatedSprite2D/Gun/Muzzle.global_transform)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprites.animation == "attack":
		set_physics_process(true)
		set_process_unhandled_input(true)
		animated_sprites.play("idle")
	elif animated_sprites.animation == "runAttack":
		set_physics_process(true)
		set_process_unhandled_input(true)
		if velocity.x!=0 || velocity.y!=0:
			animated_sprites.play("run")
		else:
			animated_sprites.play("idle")

func die():
	$AnimatedSprite2D.animation = "die"
	set_process(false)
	await $AnimatedSprite2D.animation_finished
	queue_free()
	get_tree().change_scene_to_file("res://leaderboard/control.tscn")

func pick_up_resource():
	resources_collected += 1
	


func _on_gun_cooldown_timeout() -> void:
	can_shoot = true
