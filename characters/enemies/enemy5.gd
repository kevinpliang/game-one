extends "res://characters/enemies/enemyDefault.gd"

onready var default_speed = speed
var goal = Vector2(0,0)
var at_goal = false

func _ready():
	get_new_goal()

func _physics_process(delta):
	if global_position.x-goal.x<1 and global_position.y-goal.y<1 and !at_goal:
		at_goal = true
		vel = Vector2(0,0)
		speed = 0
		still = true
		yield(get_tree().create_timer(0.5), "timeout")
		get_new_goal()
	# moves towards goal
	elif Global.player != null:
		vel = global_position.direction_to(goal)
	# calculate motion (normalized)
	if !stun and !spawning and !at_goal:
		var motion = vel.normalized() * speed
		move_and_slide(motion)

func get_new_goal():
	var old_goal = goal
	goal = Vector2(rand_range(60, 317), rand_range(35,150))
	while(old_goal.distance_to(goal) < 30):
		goal = Vector2(rand_range(60, 317), rand_range(35,150))
	speed = default_speed
	still = false
	at_goal = false

func _process(delta):
	basic_process(delta)
