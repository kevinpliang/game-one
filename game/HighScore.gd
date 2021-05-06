extends Label

func _ready():
	Global.load_game()
	text = "Press [r] to restart\nHighscore: "+ str(Global.highscore)
	
func _process(delta):
	if Global.dead:
		set_percent_visible(1)
	else:
		set_percent_visible(0)
	if Global.score > Global.highscore:
		Global.highscore = Global.score
