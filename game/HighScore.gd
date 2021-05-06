extends Label

func _ready():
	Global.load_game()
	text = str(Global.highscore)
	
func _process(delta):
	if Global.score > Global.highscore:
		Global.highscore = Global.score
