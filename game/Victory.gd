extends Label

func _ready():
	Global.load_game()
	text = "Victory!\nHighscore: "+ str(Global.highscore)
	
func _process(delta):
	if Global.score > Global.highscore:
		Global.highscore = Global.score
	if Global.win:
		text = "Victory!\nHighscore: "+ str(Global.highscore)
		set_percent_visible(-1)
	else:
		set_percent_visible(0)
