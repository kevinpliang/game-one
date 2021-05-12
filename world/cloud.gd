extends AnimatedSprite

func _ready():
	if Global.spared_justin:
		$Richard.queue_free()	
	
func _process(delta):
	pass
