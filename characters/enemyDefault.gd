extends KinematicBody2D

# 2D sprite
onready var sprite = $AnimatedSprite
onready var player = $AnimationPlayer
onready var current_color = sprite.modulate
var blood = preload("res://objects/bloodParticles.tscn")

# enemy speed and velocity vector
var alive = true
export(int) var speed = 85
var vel = Vector2(0, 0)

onready var spawning = true;
var stun = false;
var still = false;

export(int) var hp = 50
export(int) var scoreValue = 10

#powerups
export(Array, PackedScene) var drops

func _ready():
	player.play("spawn")
	yield(get_tree().create_timer(0.9), "timeout")
	spawning = false

func basic_movement(delta):
	# moves towards player
	if Global.player != null:
		vel = global_position.direction_to(Global.player.global_position)
	# calculate motion (normalized)
	if !stun and !spawning:
		var motion = vel.normalized() * speed
		move_and_slide(motion)
	
func basic_process(delta):
	# when it dies
	if hp <= 0 and alive:
		visible = false
		alive = false
		$Area2D.queue_free()
		sprite.play("hurt")
		$deathsound.play()
		if(global_position.x > 60 and global_position.x < 317 and global_position.y > 35 and global_position.y <150):
			# blood spatter
			if Global.node_creation_parent != null:
				var blood_instance = Global.instance_node(blood, global_position, Global.node_creation_parent)
				blood_instance.modulate = Color.from_hsv(current_color.h, 0.75, current_color.v)
				blood_instance.rotation = vel.angle()
			#drop
			var random = round(rand_range(0, 2))
			if random == 0:
				var powerupPicker = round(rand_range(0, drops.size()-1))
				Global.instance_node(drops[powerupPicker], global_position, Global.node_creation_parent)
		
		# score increase
		Global.enemy_count -= 1
		Global.score += scoreValue
		yield($deathsound, "finished")
		queue_free()
	elif Global.boss && !spawning:
		spawning = true
		sprite.play("hurt")
		yield(get_tree().create_timer(1), "timeout")
		sprite.play("spawn", true)
		yield(get_tree().create_timer(0.9), "timeout")
		queue_free()
	# animation
	if stun:
		sprite.play("hurt")
		global_position += vel * delta
	elif spawning:
		pass
	elif still:
		sprite.play("idle")
	elif vel[0] > 0:
		$AnimatedSprite.flip_h = false
		sprite.play("walk")
	elif vel[0] < 1:
		$AnimatedSprite.flip_h = true
		sprite.play("walk")
	elif vel[1] != 0:
		sprite.play("walk")
	else:		
		sprite.play("idle")	
		
func _on_Area2D_area_entered(area):
	# if contacted with bullet
	if area.is_in_group("enemy_damager"):
		$hitsound.play()
		stun = true
		$hitstun.start()
		sprite.play("hurt")
		modulate = Color(3,3,3)
		hp -= 10
		vel *= -4
		area.get_parent().queue_free()

func _on_hitstun_timeout():
	vel *= 0
	$pause.start()	
	
func _on_pause_timeout():
	modulate = current_color
	stun = false;
