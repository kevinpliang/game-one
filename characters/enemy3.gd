extends "res://characters/enemyDefault.gd"

var shooting = false
var bullet = preload("res://objects/enemyBullet.tscn")
var freebullet = preload("res://objects/freeBullet.tscn")
onready var rotater = $rotater

var quickfire = 0.1
var fire_rate = 3
var shots = 10
var radius = 30
var rotate_speed = 10
onready var default_speed = speed

func _ready():
	var step = 2*PI / shots
	for i in range(shots):
		var barrel = Node2D.new()
		barrel.position = global_position
		barrel.rotation = global_position.angle()
		rotater.add_child(barrel)

func _physics_process(delta):
	if(!shooting):
		still = false
		if(global_position.distance_to(Global.player.global_position) < 150 and global_position.x > 60 and global_position.x < 317 and global_position.y > 35 and global_position.y <150):
			if !shooting and !stun:
				still = true
				shooting = true
				shoot()	
			speed = 0	
		else:
			speed = default_speed
		basic_movement(delta)

func shoot():
	for s in rotater.get_children():
		var bullet = Global.instance_node(freebullet, global_position, Global.node_creation_parent)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation
		yield(get_tree().create_timer(quickfire), "timeout")
	yield(get_tree().create_timer(fire_rate), "timeout")
	shooting = false
	still = false

func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed + delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	basic_process(delta)
