extends AnimatedSprite

var velocity = Vector2(1,0)
onready var speed = Global.bullet_speed

# will only check mouse position once
var look_once = true

func _process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	# rotated so bullet follows velocity direction not axis
	if Global.weapon == 3:
		global_position += velocity * speed * delta
	else:
		global_position += velocity.rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
