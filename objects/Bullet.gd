extends AnimatedSprite

var velocity = Vector2(1,0)
var speed = 100

# will only check mouse position once
var look_once = true

func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	# rotated so bullet follows velocity direction not axis
	global_position += velocity.rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
