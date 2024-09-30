extends Area2D
@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480,720)
signal pickup
signal hurt

func _ready() -> void:
	pass 

func _process(delta: float):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x,0,screensize.x)
	position.y= clamp(position.y,0,screensize.y)
	
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "idle"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start() -> void:
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
