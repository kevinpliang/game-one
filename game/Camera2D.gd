extends Camera2D

var screen_shake_start = false
var shake_intensity = 0

func _read():
	Global.camera = self
	
func _exit_tree():
	Global.camera = null
	
func _process(delta):
	pass
