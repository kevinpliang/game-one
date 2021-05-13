extends KinematicBody2D

onready var label = $Label
onready var animation = $AnimationPlayer
onready var head = $HeadSprite
onready var sprite = $BodySprite

onready var enemyBullet = preload("res://objects/enemyBullet.tscn")
onready var freeBullet = preload("res://objects/freeBullet.tscn")

var canTalk = false
var cutscene = false
var boss_mode = false

#var dialogue = ["...", ".....", ".......", "my little bro...\nhasn't come back up.", "he's just a kid.."]
var d_speed = [0.8, 0.8, 0.8, 0.4, 0.4]
var d_index = 0
var dialogue = []

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

# progress dialogue
func _input(event):
	if Input.is_action_pressed("interact") and canTalk and !animation.is_playing():
		label.text = dialogue[d_index]
		animation.playback_speed = d_speed[d_index]
		animation.play("show_label")
		Global.player.stationary = true
		yield(animation, "animation_finished")
		d_index += 1
		Global.player.stationary = false

# start fight cutscene
func startFight():
	boss_mode = true
	Global.player.stationary = false
	sprite.play("get-up")
	yield(get_tree().create_timer(2), "timeout")
	$sound.play()
	label.text = "YOU MONSTER!!!"
	label.rect_position.y -= 22
	animation.playback_speed = 2
	animation.play("show_label")
	animation.playback_speed = 1
	Global.player.stationary = false
	sprite.play("attack-intro")
	yield(get_tree().create_timer(0.3), "timeout")
	attack_intro()
	animation.queue("jump_and_land")
	
	$CollisionPolygon2D.queue_free()
	$interactRange.queue_free()
	
	attack_clock()

func attack_intro() -> void:
	for wave in 1:
		var dir = global_position.direction_to(Global.player.global_position)
		var rot = get_angle_to(Global.player.global_position)
		for i in 4:
			for angle in range(-60,60,5):
				var radians = deg2rad(angle)
				var shot = Global.instance_node(freeBullet, global_position, Global.node_creation_parent)
				shot.rotation = rot+radians
				shot.speed = 100
			yield(get_tree().create_timer(0.12), "timeout")
		yield(get_tree().create_timer(0.8), "timeout")

func attack_clock() -> void:
	#sprite.play("attack-2")
	print("attack clock")
	yield(get_tree().create_timer(2), "timeout")
	sprite.play("idle")	
	var numBullets = 50
	var ringArray = []
	#$sound.play()
	for radius in range(0, 150, 10):
		var step = 2*PI / numBullets	
		var ring = [numBullets]
		for i in range(numBullets):
			var pos = global_position+Vector2(220-radius,0).rotated(step * i)
			var bullet = Global.instance_node(enemyBullet, pos, Global.node_creation_parent)
			ring.append(bullet)
			bullet.freeze = true
		ringArray.append(ring)
		yield(get_tree().create_timer( 0.5455), "timeout")
	
	# deletes bullets
#	for i in range(ringArray.size()):
#		var ring = ringArray.pop_back()
#		for j in range(numBullets):
#			var bullet = ring[j]
#			if bullet != null:
#				bullet.queue_free()


# dialogue range enter
func _on_interactRange_area_entered(area):
	if area.is_in_group("player"):
		canTalk = true
	elif area.is_in_group("enemy_damager") and !boss_mode:
		area.get_parent().queue_free()

# dialogue range exit
func _on_interactRange_area_exited(area):
	if $interactRange != null and !boss_mode and !cutscene:
		if animation.is_playing():
			yield(animation, "animation_finished")
		if area != null and area.is_in_group("player"):
			# if you're out of dialogue, start boss fight intro sequence
			# for some reason queue_free() on the interactRange seems to emit this signal again..
			if d_index >= dialogue.size() and not boss_mode:
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
