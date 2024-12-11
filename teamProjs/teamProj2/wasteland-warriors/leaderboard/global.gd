extends Node

var save_path := "user://highscore.ini"

var score = 0

var scores = [ # records top 5 scores
	[0, ""],
	[0, ""],
	[0, ""],
	[0, ""],
	[0, ""] # score, Name
]

func uploadscore(name) -> void:
	var c = [score, name]
	var l = c
	for i in range(0, 5):
		if c[0] > scores[i][0]:
			l = scores[i]
			scores[i] = c
			c = l
	savescores()

func getscores() -> Array:
	return scores

func loadscores() -> void:
	var config_file = ConfigFile.new()
	var error := config_file.load(save_path)
	
	if error:
		print("An error happened while loading data", error)
		return
	
	for x in range(0, 5):
		scores[x] = config_file.get_value("score" + str(x), "score", [0, ""])

func savescores() -> void:
	var config_file := ConfigFile.new()
	
	for x in range(0, 4):
		config_file.set_value("score" + str(x), "score", scores[x])
	
	var error := config_file.save(save_path)
	if error:
		print("An error happened while saving data", error)

func _ready():
	loadscores()
