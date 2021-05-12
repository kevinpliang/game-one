extends KinematicBody2D

onready var label = $Label
onready var animation = $AnimationPlayer
onready var head = $HeadSprite
onready var sprite = $BodySprite

var canTalk = false
var cutscene = false
var boss_mode = false

var dialogue = ["...", ".....", ".......", "my little bro...\nhasn't come back up."]
var d_speed = [0.8, 0.8, 0.8, 0.4]
var d_index = 0

func _process(delta):
	if d_index >= dialogue.size():
		canTalk = false
	if !animation.is_playing() and !cutscene:
		if canTalk:		
			label.text = "[E]"
			label.percent_visible = 1
		else:
			label.text = ""
			label.percent_visible = 0

func _input(event):
	if Input.is_action_pressed("interact") and canTalk and !animation.is_playing():
		label.text = dialogue[d_index]
		animation.playback_speed = d_speed[d_index]
		animation.play("show_label")
		Global.player.stationary = true
		yield(animation, "animation_finished")
		d_index += 1
		Global.player.stationary = false

func startFight():
	boss_mode = true
	print("you monster!")
	animation.queue("get_up")
	yield(animation, "animation_finished")
	print("ok")
	$sound.play()
	$CollisionPolygon2D.queue_free()
	$interactRange.queue_free()
	Global.player.stationary = false

func _on_interactRange_area_entered(area):
	if area.is_in_group("player"):
		canTalk = true
	elif area.is_in_group("enemy_damager") and !boss_mode:
		area.get_parent().queue_free()

func _on_interactRange_area_exited(area):
	if animation.is_playing():
		yield(animation, "animation_finished")
	if area.is_in_group("player"):
		if d_index >= dialogue.size():
			cutscene = true
			yield(get_tree().create_timer(1.5), "timeout")
			Global.emit_signal("stop_music")
			label.text = "wait..."
			animation.playback_speed = 0.5
			Global.player.stationary = true
			animation.play("show_label")
			yield(animation, "animation_finished")
			head.hide()
			sprite.play("realize")
			yield(get_tree().create_timer(1.5), "timeout")
			label.text = "where'd you get\nthat shirt?"
			animation.play("show_label")
			yield(animation, "animation_finished")
			startFight()
		canTalk = false
