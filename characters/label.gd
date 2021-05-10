extends Label

func _process(delta):
	if Global.level == 1:
		set("custom_colors/font_color", Color(1, 1, 1))
	elif Global.level == 2:
		set("custom_colors/font_color", Color(0, 0, 0))
