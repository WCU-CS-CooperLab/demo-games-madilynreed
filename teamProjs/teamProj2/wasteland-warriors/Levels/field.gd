extends Node

@export var cyborg_scene : PackedScene
@export var finalBoss_scene : PackedScene

var level = 1
var screensize = Vector2.ZERO
var playing = false

func _ready():
	spawn_cyborgs(1)
	playing = true

func _process(delta):
	if (playing and get_tree().get_nodes_in_group("enemies").size() == 0):
		next_wave()

func spawn_cyborgs(_level, pos=null):
	level = _level
	if pos == null:
		$EnemyPath/EmemySpawn.progress = randi()
		pos = $EnemyPath/EmemySpawn.position
	for n in (level * 3):
		var c = cyborg_scene.instantiate()
		c.screensize = screensize
		c.start(pos)
		call_deferred("add_child", c)
		$EnemyPath/EmemySpawn.progress = randi()
		pos = $EnemyPath/EmemySpawn.position

func spawn_final(pos = null):
	if pos == null:
		$EnemyPath/EmemySpawn.progress = randi()
		pos = $EnemyPath/EmemySpawn.position
		var f = finalBoss_scene.instantiate()
		f.screensize = screensize
		f.start(pos)
		call_deferred("add_child", f)
		$EnemyPath/EmemySpawn.progress = randi()
		pos = $EnemyPath/EmemySpawn.position

func _on_wave_timer_timeout() -> void:
	next_wave()

func next_wave():
	level += 1
	if level == 2:
		spawn_final()
	else:
		spawn_cyborgs(level)
		$WaveTimer.stop()
		$WaveTimer.start()

func _on_audio_stream_player_2d_finished() -> void:
	$Music.play()
