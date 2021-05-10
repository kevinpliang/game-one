extends Label
	
func _process(delta):
	if Global.dead:
		set_percent_visible(1)
	else:
		set_percent_visible(0)
	if Global.level == 1:
		set("custom_colors/font_color", Color(0.717647, 0.87451, 0.984314))
	elif Global.level == 2:
		set("custom_colors/font_color", Color(0.6, 0.6, 0.6))
		
