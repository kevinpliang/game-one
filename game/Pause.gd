extends Control

func _input(event):
	if Input.is_action_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			$Menu.hide()
		else:
			get_tree().paused = true
			$Menu.show()
