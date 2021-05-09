extends Label
	
func _process(delta):
	if Global.dead:
		set_percent_visible(1)
	else:
		set_percent_visible(0)
