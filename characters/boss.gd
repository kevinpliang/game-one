extends KinematicBody2D

# 2D sprite
onready var sprite = $AnimatedSprite
onready var player = $AnimationPlayer
onready var smoke = $smokeFX
onready var text = $text
onready var rotater = $rotater
onready var current_color = sprite.modulate
onready var default_speed = speed
onready var guards = preload("res://characters/enemies/guard.tscn")
onready var freebullet = preload("res://objects/freeBullet.tscn")
onready var enemybullet = preload("res://objects/enemyBullet.tscn")
onready var shirt = preload("res://objects/shirt.tscn")

# enemy speed and velocity vector
var alive = true
export(int) var speed = 20
var vel = Vector2(0, 0)
var quickfire = 0.2
var rotate_speed = 40
var radius = 20
var guardnum = 5

var has_been_scared = false

var stationary = false
var scared = false
var in_action = false
var exiting = false

export(int) var maxhp = 1
onready var hp = maxhp
export(int) var scoreValue = 0

#powerups
export(Array, PackedScene) var drops

func _ready():
	stationary = true
	in_action = true
	player.play("entrance")
	print(global_position)
	var step = 2*PI / guardnum
	for i in range(guardnum):
		var barrel = Node2D.new()
		var pos = Vector2(radius,0).rotated(step * i)
		barrel.position = pos
		barrel.rotation = pos.angle()
		rotater.add_child(barrel)
	if(Global.ish_mode):
		Global.player.label.text = "bruv best watch oneself"
		Global.player.animations.play("show_label")
	Global.player.connect("choice_made", self, "_on_choice_made")
	
# after the cutscene entrance
func _on_AnimationPlayer_animation_finished(anim_name):
	stationary = false
	in_action = false

func _physics_process(delta):
	# calculate to-player vector
	if Global.player != null:
		vel = global_position.direction_to(Global.player.global_position)
	# calculate motion (normalized)
	if scared: # move away
		vel *= -1
		var motion = vel.normalized() * speed
		move_and_slide(motion)
	elif !stationary: 
		var motion = vel.normalized() * speed
		move_and_slide(motion)
	# set boundaries
	if !exiting:
		global_position.x = clamp(global_position.x, 60, 317)
		global_position.y = clamp(global_position.y, 50, 165)
	else:
		move_and_slide(Vector2(0, -1)*200)

func choose_attack():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random = rng.randi_range(0, 2)
	if random == 0:
		attack_zero()
	elif random == 1:
		attack_one()
	elif random == 2:
		attack_two()

func attack_zero():
	print("attack zero")
	stationary = true
	in_action = true
	rotate_speed = 80
	var this_quickfire = 0.25
	sprite.play("attack-0")
	yield(get_tree().create_timer(1), "timeout")
	for i in 30:
		randomize()
		var random = round(rand_range(1,10))
		for s in rotater.get_children():
			var bullet = Global.instance_node(freebullet, global_position, Global.node_creation_parent)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		if random == 3:
			var chain = 3
			if has_been_scared:
				chain = 5
			for s in chain:
				var bullet = Global.instance_node(enemybullet, global_position, Global.node_creation_parent)
				yield(get_tree().create_timer(0.05), "timeout")
		yield(get_tree().create_timer(this_quickfire), "timeout")
	stationary = false
	in_action = false	

func attack_one():
	print("attack one!")
	in_action = true
	stationary = true
	rotate_speed = 100
	var this_quickfire = 0.1
	if has_been_scared:
		this_quickfire = 0.09
	sprite.play("attack-1")
	yield(get_tree().create_timer(0.7), "timeout")
	sprite.play("idle")
	yield(get_tree().create_timer(1), "timeout")
	for i in 15:
		for s in rotater.get_children():
			var bullet = Global.instance_node(enemybullet, global_position, Global.node_creation_parent)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		yield(get_tree().create_timer(this_quickfire), "timeout")
	stationary = false
	in_action = false
	
func attack_two():
	print("attack two!")
	in_action = true
	stationary = true
	sprite.play("attack-2")
	var this_quickfire = 0.1
	var this_radius = 100
	yield(get_tree().create_timer(2), "timeout")
	sprite.play("idle")
	
	var numBullets = 12
	if has_been_scared:
		numBullets = 15
		
	var step = 2*PI / numBullets	
	var bulletArray = [numBullets]
	for i in range(numBullets):
		var pos = global_position + Vector2(this_radius,0).rotated(step * i)
		pos.y-=20
		var bullet = Global.instance_node(enemybullet, pos, Global.node_creation_parent)
		bulletArray.append(bullet)
		bullet.freeze = true
		
	yield(get_tree().create_timer(1.5), "timeout")
	for i in range(numBullets):
		var bullet = bulletArray.pop_back()
		if bullet != null:
			bullet.freeze = false
	stationary = false
	in_action = false

func attack_runAway():
	has_been_scared = true
	scared = true
	in_action = true
	stationary = false
	var quickfire = 0.2
	var rotate_speed = 40
	speed = 50
	sprite.play("scared-walk")
	text.play("scared")	
	if(Global.ish_mode):
		Global.player.label.text = "you scared?"
		Global.player.animations.play("show_label")
	yield(get_tree().create_timer(1), "timeout")
	# spawn guards in a circle around him
	if alive:
		var bugCatcher = Global.enemy_count
		for s in rotater.get_children():
			var guard = Global.instance_node(guards, global_position, Global.node_creation_parent)
			guard.position = s.global_position
			Global.enemy_count+=1
			yield(get_tree().create_timer(quickfire), "timeout")
			
		# wait for guards to die
		while(Global.enemy_count > 1):
			print(Global.enemy_count)
			yield(get_tree().create_timer(1), "timeout")
	text.play("default")
	scared = false
	in_action = false
	if alive:
		stationary = false		
		speed = default_speed


func _process(delta):
	# rotate rotater
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
	if !Global.dead and alive:	
		if hp <= (0.5*maxhp) and !has_been_scared and !in_action and alive:
			attack_runAway()
		
		if hp <= (0.95*maxhp) and hp > 0 and !in_action and global_position.distance_to(Global.player.global_position) < 80:
			choose_attack()	
		
	# if neither stationary nor in an action, walk
	if !stationary and !in_action and alive:
		sprite.play("walk")
	# if stationary but not in an actual, idle
	elif !in_action and alive:
		sprite.play("idle")	
	
	# flip sprite depending on which way you're going
	if !stationary:
		if vel[0] > 0:
			sprite.flip_h = false
		elif vel[0] < 1:
			sprite.flip_h = true
			
	# death
	if hp <= 0 and alive:
		alive = false
		stationary = true
		in_action = true
		speed = 0
		vel = Vector2(0,0)
		$deathsound.play()
		Global.boss1_dead = true
		$hitbox.queue_free()
		Global.vulnerable = false
		# score increase
		scoreValue = 300-(OS.get_unix_time()-Global.boss_start_time)
		# score calculated by adding time seconds less than 5 minutes
		Global.score += scoreValue
		if(Global.ish_mode):
			Global.player.label.text = "that was so easy"
			Global.player.animations.play("show_label")
		# death animation
		text.stop()
		sprite.play("death")
		yield(get_tree().create_timer(2.375), "timeout")
		smoke.play("wide-1")
		Global.player.choice.text = "Spare him?\n[1] Yes [2] No"
		Global.player.animations.queue("show_choice")

func _on_choice_made(choice):
	var death_location = global_position
	death_location.y -= 15
	if choice == 1: # spared
		Global.spared_justin = true
		sprite.play("death", true)
		yield(get_tree().create_timer(3.75), "timeout")
		sprite.play("exit")
		yield(get_tree().create_timer(0.6), "timeout")
		exiting = true
	elif choice == 2: # nope
		Global.spared_justin = false
		sprite.play("not-spared")
		yield(get_tree().create_timer(2), "timeout")
		queue_free()
	Global.instance_node(shirt, death_location, Global.node_creation_parent)

func _on_hitbox_area_entered(area):
	# if contacted with bullet
	if area.is_in_group("enemy_damager"):
		$hitsound.play()
		hp -= Global.damage
		area.get_parent().queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
