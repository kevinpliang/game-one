extends KinematicBody2D

# 2D sprite
onready var sprite = $AnimatedSprite
onready var current_color = sprite.modulate
var blood = preload("res://objects/bloodParticles.tscn")

# enemy speed and velocity vector
export(int) var speed = 70
var vel = Vector2(0, 0)

var stun = false;

export(int) var hp = 50
export(int) var scoreValue = 10

#powerups
export(Array, PackedScene) var drops

func basic_movement(delta):
	# moves towards player
	if Global.player != null and !stun:
		vel = global_position.direction_to(Global.player.global_position)
	# calculate motion (normalized)
	var motion = vel.normalized() * speed
	move_and_slide(motion)
	
func basic_process(delta):
	# when it dies
	if hp <= 0:
		sprite.play("hurt")
		if(global_position.x > 60 and global_position.x < 317 and global_position.y > 35 and global_position.y <150):
			# blood spatter
			if Global.node_creation_parent != null:
				var blood_instance = Global.instance_node(blood, global_position, Global.node_creation_parent)
				blood_instance.modulate = Color.from_hsv(current_color.h, 0.75, current_color.v)
				blood_instance.rotation = vel.angle()
			#drop
			var random = round(rand_range(0, 4))
			if random == 0:
				var powerupPicker = round(rand_range(0, drops.size()-1))
				Global.instance_node(drops[powerupPicker], global_position, Global.node_creation_parent)
		
		# score increase
		Global.score += scoreValue
		queue_free()
	# animation
	if stun:
		sprite.play("hurt")
		global_position += vel * delta
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
		$hitstun.start()
		sprite.play("hurt")
		modulate = Color(3,3,3)
		hp -= 10
		stun = true
		vel *= -4
		area.get_parent().queue_free()

func _on_hitstun_timeout():
	vel *= 0
	$pause.start()	
	
func _on_pause_timeout():
	modulate = current_color
	stun = false;
