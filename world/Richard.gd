extends KinematicBody2D

onready var label = $Label
onready var animation = $AnimationPlayer
onready var head = $HeadSprite
onready var sprite = $BodySprite

var canTalk = false
var cutscene = false

var dialogue = ["...", ".....", ".......", "my little bro...\nhasn't come back up.", "he's a big baby..\ni'm worried."]
var d_speed = [0.8, 0.8, 0.8, 0.4, 0.4]
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
	if Input.is_action_pressed("interact") and canTalk:
		label.text = dialogue[d_index]
		animation.playback_speed = d_speed[d_index]
		animation.play("show_label")
		Global.player.stationary = true
		yield(animation, "animation_finished")
		d_index += 1
		Global.player.stationary = false

func startFight():
	print("you monster!")

func _on_interactRange_area_entered(area):
	if area.is_in_group("player"):
		canTalk = true

func _on_interactRange_area_exited(area):
	if animation.is_playing():
		yield(animation, "animation_finished")
	if area.is_in_group("player"):
		if d_index >= dialogue.size():
			cutscene = true
			yield(get_tree().create_timer(1.5), "timeout")
			head.hide()
			label.text = "wait..."
			animation.playback_speed = 0.5
			animation.play("show_label")
			yield(animation, "animation_finished")
			sprite.play("realize")
			yield(get_tree().create_timer(1.5), "timeout")
			label.text = "where'd you get\nthat shirt?"
			animation.play("show_label")
			yield(animation, "animation_finished")
			startFight()
		canTalk = false
