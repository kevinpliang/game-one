extends Label

func _ready():
	Global.load_game()
	text = "Victory!\nHighscore: "
	if Global.weapon == 1: 
		text += str(Global.highscore_easy) + "\n(Easy)"
	elif  Global.weapon == 2: 
		text += str(Global.highscore) + "\n(Normal)"
	elif  Global.weapon == 3: 
		text += str(Global.highscore_hard) + "\n(Hard)"
	
func _process(delta):
	if Global.weapon == 1: 
		if Global.score > Global.highscore_easy:
			Global.highscore_easy = Global.score
	elif  Global.weapon == 2: 
		if Global.score > Global.highscore:
			Global.highscore = Global.score
	elif  Global.weapon == 3: 
		if Global.score > Global.highscore_hard:
			Global.highscore_hard = Global.score	
		Global.highscore = Global.score
	
	text = "Victory!\nHighscore: "
	if Global.win:
		if Global.weapon == 1: 
			text += str(Global.highscore_easy) + "\n(Easy)"
		elif  Global.weapon == 2: 
			text += str(Global.highscore) + "\n(Normal)"
		elif  Global.weapon == 3: 
			text += str(Global.highscore_hard) + "\n(Hard)"
		set_percent_visible(-1)
	else:
		set_percent_visible(0)
