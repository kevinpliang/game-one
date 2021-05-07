extends KinematicBody2D

# 2D sprite
onready var zee_sprite = $ZeeSprite
onready var animations = $animations
var bullet = preload("res://objects/Bullet.tscn")

# player speed and velocity vector
export var speed = 75
var vel = Vector2(0, 0)

# stuff
var fire_rate = 0.5
var can_shoot = true

signal okay

func _ready():
	Global.player = self
	Global.dead = false
	zee_sprite.play("idle")
	
func _exit_tree():
	Global.player = null
 
func _physics_process(delta):
	# calculate velocity
	vel.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vel.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) / float(2)
	
	# set boundaries
	global_position.x = clamp(global_position.x, 60, 317)
	global_position.y = clamp(global_position.y, 35, 150)
	
	# calculate motion (normalized)
	if !Global.dead:
		var motion = vel.normalized() * speed
		move_and_slide(motion)

func _process(delta):
	if !Global.dead:
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
		# print(get_viewport().get_mouse_position())
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$fireRate.start()
		can_shoot = false

# for restart
func _input(event):
	if(Input.is_action_pressed("ui_accept")):
		emit_signal("okay")

func _on_fireRate_timeout():
	can_shoot = true
	$fireRate.wait_time = fire_rate
	
# if you die
func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("player_damager"):
		if area.is_in_group("player_damager"):
			area.get_parent().queue_free()
		Global.dead = true
		$hurtbox.queue_free()
		$deathsound.play()
		animations.play("death")
		Global.save_game()		
		# restart 
		yield(self, "okay")
		Global.boss = false;
		get_tree().reload_current_scene()

func _on_animations_animation_finished(anim_name):
	if(anim_name == "death"):
		animations.stop()
