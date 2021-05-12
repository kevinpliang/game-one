extends "res://characters/zee.gd"

var windup = false 
var airborne = false #lmfao
var got_that = false

var landed_on_2 = false
var arrived_in_2 = false

func _ready():
	Global.player = self
	Global.dead = false
	Global.player.connect("choice_made", self, "_on_choice_made")	
	if Global.level == 1:
		label.text = "red shirt acquired!"
		animations.queue("show_label")
		yield(animations, "animation_finished")
		
		while !got_that:
			label.text = "right click to dodge"
			animations.queue("show_label")
			yield(animations, "animation_finished")
			label.text = "you can control your direction when airborne"
			animations.queue("show_label")
			yield(animations, "animation_finished")
			label.text = "you are invincible during the first part of the dodge"
			animations.queue("show_label")
			yield(animations, "animation_finished")
			label.text = "but vulnerable when landing"
			animations.queue("show_label")
			yield(animations, "animation_finished")
			animations.stop()
			choice.text = "Did you get that?\n[1] Yes [2] No"
			animations.queue("show_choice")
			yield(self, "choice_made")
		zee_sprite.play("roll")
		yield(get_tree().create_timer(0.166), "timeout")
		zee_sprite.play("float")
		floating = true
		label.text = "wait what"
		animations.queue("show_label")

func _on_choice_made(choice):
	if choice == 1:
		got_that = true
	elif choice == 2:
		got_that = false

func _process(delta):
	if Global.level == 2 and !arrived_in_2:
		global_position = Vector2(192, 222)
		zee_sprite.global_position = Vector2(192,222)
		arrived_in_2 = true
		if !landed_on_2:
			landed_on_2 = true
			floating = true
			animations.play("float_to_middle")
			yield(animations, "animation_finished")
			floating = false
			can_shoot = true
			global_position = Vector2(191.946, 97)
					
	if floating:
		can_shoot = false
		zee_sprite.play("float")
		
	# dodge..
	elif !dodging and !stationary and Input.is_action_pressed("right_click"):
		zee_sprite.play("roll")
		dodging = true
		can_shoot = false
		
		# wind up
		#windup = true
		self.remove_child(hurtbox)
		#yield(get_tree().create_timer(0.166), "timeout")
		#windup = false		
		
		# fix: getting hit during dodge makes him loop dodge after death
		# uhh can't replicate..
		
		# airborne
		airborne = true
		yield(get_tree().create_timer(0.333), "timeout")
		airborne = false
		self.add_child(hurtbox)
		
		# vulnerable
		yield(get_tree().create_timer(0.333), "timeout")
		dodging = false
		can_shoot = true
		
	if global_position.y <= 0 and Global.level == 1:
		he_gone(Global.level)
				
func _physics_process(delta):
	# roll
	if airborne:
		move_and_slide(vel.normalized() * speed *1.8)
	elif floating:
		move_and_slide(Vector2(0,-1)*30)

func he_gone(level):
	Global.boss_mode = false
	Global.level = 1.5
	Global.node_creation_parent.loadLevel()
	floating = true
