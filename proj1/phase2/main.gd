extends Node
@export var coin_scene : PackedScene
@export var cacti_scene : PackedScene
@export var powerup_scene : PackedScene
@export var playtime = 30
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$powerupTimer.wait_time = randf_range(5, 10)
		$powerupTimer.start()
		spawn_cacti()

func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$player.screensize = screensize
	$player.hide()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$player.start()
	$player.show()
	$gameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))
		$levelSound.play()

func spawn_cacti():
	get_tree().call_group("obstacles", "queue_free")
	for i in level -1 :
		var c := cacti_scene.instantiate()
		add_child(c)
		# c.screensize = screensize
		c.position = Vector2(randi_range(0,screensize.x),randi_range(0,screensize.y))


func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func game_over():
	playing = false
	$gameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$HUD.show_game_over()
	$player.die()
	$endSound.play()
	

func _on_player_hurt() -> void:
	game_over()

func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$coinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$powerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
	
	


func _on_hud_start_game() -> void:
	new_game()


func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	
