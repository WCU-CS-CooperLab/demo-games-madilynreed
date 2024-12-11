extends CanvasLayer

signal start_game
@onready var time_label = $MarginContainer/HBoxContainer/TimeLabel
var elapsed_time = 0
var score = 0
	
func _process(delta: float) -> void:
	elapsed_time += delta
	time_label.text = str(elapsed_time).pad_decimals(2)
	Global.score = float(elapsed_time)
