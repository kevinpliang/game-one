extends Sprite

func _process(delta):
	Global.player.floating = true
	Global.player.global_position = Vector2(192, 100)
	if !Global.player.animations.is_playing() && Global.level == 1.5:
		Global.player.animations.play("float_to_top")

func _on_AnimationPlayer_animation_finished(anim_name):
	Global.level = 2
	Global.node_creation_parent.loadLevel()
	queue_free()
	
