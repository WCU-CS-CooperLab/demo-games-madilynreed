extends Control

func _ready() -> void:
	var scores = Global.getscores()
	$Display.text = "Your Score: " + str(Global.score) + "\nHigh Scores: \n\n"
	for x in range(0, 5):
		$Display.text = $Display.text + str(x+1) + ". " + scores[x][1] + " - " + str(scores[x][0]).pad_decimals(2) + "\n"
