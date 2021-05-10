extends "res://characters/zee.gd"

var windup = false 
var airborne = false #lmfao

func _ready():
	Global.player = self
	Global.dead = false
	zee_sprite.play("float")
	floating = true

func _process(delta):
	if floating:
		can_shoot = false
		zee_sprite.play("float")
	elif !dodging and Input.is_action_pressed("right_click"):
		zee_sprite.play("roll")
		dodging = true
		can_shoot = false
		
		# wind up
		windup = true
		self.remove_child(hurtbox)
		yield(get_tree().create_timer(0.166), "timeout")
		windup = false		
		
		# airborne
		airborne = true
		yield(get_tree().create_timer(0.333), "timeout")
		airborne = false
		self.add_child(hurtbox)
		
		# vulnerable
		yield(get_tree().create_timer(0.333), "timeout")
		dodging = false
		can_shoot = true

	if !Global.dodge_tutorial_played and Global.level == 2:
		Global.dodge_tutorial_played = true
		label.text = "right click to dodge"
		animations.play("show_label")
		yield(animations, "animation_finished")
		label.text = "you can control your direction when airborne"
		animations.play("show_label")
		yield(animations, "animation_finished")
		label.text = "you are invincible during the first part of the dodge"
		animations.queue("show_label")
		yield(animations, "animation_finished")
		label.text = "but vulnerable when landing"
		animations.queue("show_label")
		yield(animations, "animation_finished")
		animations.stop()
		
func _physics_process(delta):
	# roll
	if airborne:
		move_and_slide(vel.normalized() * speed *1.8)
	elif floating:
		move_and_slide(Vector2(0,-1)*30)

func _on_VisibilityNotifier2D_screen_exited():
	print("he gone")
	Global.boss_mode = false
	Global.level = 2
	Global.node_creation_parent.loadLevel()
	floating = false
