extends AnimatedSprite

var velocity = Vector2(1,0)
var speed = 150

# will only check player position once
var look_once = true

func _process(delta):
	if look_once:
		look_at(Global.player.global_position)
		look_once = false
	# rotated so bullet follows velocity direction not axis
	global_position += velocity.rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
