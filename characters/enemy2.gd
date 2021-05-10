extends "res://characters/enemyDefault.gd"

var shooting = false
var bullet = preload("res://objects/enemyBullet.tscn")
var fire_rate = 1
onready var default_speed = speed

func _physics_process(delta):
	if(!shooting):
		still = false
		if(global_position.distance_to(Global.player.global_position) < 100 and global_position.x > 60 and global_position.x < 317 and global_position.y > 35 and global_position.y <150):
			if !shooting and !stun and alive:
				still = true
				shooting = true
				shoot()	
			speed = 0	
		else:
			speed = default_speed
		basic_movement(delta)

func shoot():
	Global.instance_node(bullet, global_position, Global.node_creation_parent)
	yield(get_tree().create_timer(fire_rate), "timeout")
	shooting = false
	still = false

func _process(delta):
	basic_process(delta)
