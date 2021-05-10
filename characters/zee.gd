extends KinematicBody2D

# 2D sprite
onready var zee_sprite = $ZeeSprite
onready var animations = $animations
onready var hurtbox = $hurtbox
onready var label = $text/label
onready var choice = $text/choice
export var health = 1
var bullet = preload("res://objects/Bullet.tscn")

# player speed and velocity vector
export var speed = 75
var vel = Vector2(0, 0)

# stuff
var fire_rate = 0.5
var can_shoot = true
var dodging = false
var choosing = false
var floating = false

# fun
var konamish = ["ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right", "ui_accept"]
var ish_index = 0

signal okay
signal choice_made(choice)

func _ready():
	Global.player = self
	Global.dead = false
	zee_sprite.play("idle")
	
func _physics_process(delta):
	# calculate velocity
	vel.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vel.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) / float(2)
	
	# set boundaries
	if floating:
		pass
	else:
		global_position.x = clamp(global_position.x, 59, 318)
		global_position.y = clamp(global_position.y, 34, 150)	
		# calculate motion (normalized)
		if !Global.dead and !dodging:
			var motion = vel.normalized() * speed
			move_and_slide(motion)

func _process(delta):
	if !Global.dead and !dodging:
		if vel[0] > 0:
			$ZeeSprite.flip_h = false
			zee_sprite.play("walk")
		elif vel[0] < 0:
			$ZeeSprite.flip_h = true
			zee_sprite.play("walk")
		elif vel[1] < 0:
			zee_sprite.play("walk")
		elif vel[1] > 0:
			zee_sprite.play("walk")
		else:		
			zee_sprite.play("idle")
	if can_shoot and !Global.dead and Input.is_action_pressed("left_click") and Global.node_creation_parent != null:
		# default smg
		if Global.weapon == 1:
			$fireRate.wait_time = 0.2
			Global.bullet_speed = 200
			Global.damage = 6
			Global.instance_node(bullet, global_position, Global.node_creation_parent)
		# easy minigun
		elif Global.weapon == 2:
			$fireRate.wait_time = 0.5
			Global.damage = 10
			Global.bullet_speed = 100
			Global.instance_node(bullet, global_position, Global.node_creation_parent)
		# hard shotgun
		elif Global.weapon == 3:
			$fireRate.wait_time = 1.5
			Global.bullet_speed = 250
			Global.damage = 15
			var dir = global_position.direction_to(get_global_mouse_position())
			var rot = get_angle_to(get_global_mouse_position())
			for angle in [-.25, 0, .25]:
				var radians = deg2rad(angle)
				var shot = Global.instance_node(bullet, global_position, Global.node_creation_parent)
				shot.velocity = dir.rotated(angle)
		$fireRate.start()
		can_shoot = false

# for restart
func _input(event):
	if(Input.is_action_pressed(konamish[ish_index])):
		ish_index+=1
		if ish_index == konamish.size():
			ish_index = 0
			#activate ish mode
			if Global.dead:
				Global.ish_mode = true
				print("ish mode activate")
				emit_signal("okay")
	elif event is InputEventKey and event.pressed:
		ish_index = 0
	if(Input.is_action_pressed("ui_accept")):
		# current mode
		emit_signal("okay")
	elif(Input.is_action_pressed("num_1")):
		# easy mode
		if Global.dead:
			Global.weapon = 1
			emit_signal("okay")
		if choosing:
			emit_signal("choice_made", 1)
	elif(Input.is_action_pressed("num_2")):
		# normal mode
		if Global.dead:
			Global.weapon = 2
			emit_signal("okay")
		if choosing:
			emit_signal("choice_made", 2)
	elif(Input.is_action_pressed("num_3")):
		# hard mode
		if Global.dead:
			Global.weapon = 3
			emit_signal("okay")
		if choosing:
			emit_signal("choice_made", 3)

func _on_fireRate_timeout():
	can_shoot = true
	$fireRate.wait_time = fire_rate
	
# if you die
func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("player_damager") and Global.vulnerable:
		health -= 1
		if area.is_in_group("player_damager"):
			area.get_parent().visible = false
		if health <= 0:
			print(Global.ish_mode)
			Global.dead = true
			$hurtbox.queue_free()
			$deathsound.play()
			animations.play("death")
			if Global.ish_mode:
				yield(animations, "animation_finished")
				label.text = "damn this game is impossible"
				animations.queue("show_label")
			Global.save_game()
			# restart 
			yield(self, "okay")
			Global.boss_mode = false;
			Global.boss1_dead = false;
			get_tree().reload_current_scene()
		else:
			label.text = "that didn't hit me"
			animations.queue("show_label")
			self.remove_child(hurtbox)
			yield(get_tree().create_timer(1.5), "timeout")
			self.add_child(hurtbox)

func _on_animations_animation_finished(anim_name):
	if(anim_name == "death"):
		animations.stop()
	if(anim_name == "show_choice"):
		choosing = true
		yield(self, "choice_made")
		choosing = false
		choice.text = ""
