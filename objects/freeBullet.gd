extends AnimatedSprite

var speed = 50

func _process(delta):
	# just moves forward
	global_position += transform.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
