extends KinematicBody2D

# 2D sprite
onready var sprite = $AnimatedSprite
var blood = preload("res://objects/bloodParticles.tscn")

# enemy speed and velocity vector
export var speed = 70
var vel = Vector2(0, 0)

var stun = false;
var hp = 50;

func _ready():
	sprite.play("idle")
 
func _physics_process(delta):
	if Global.player != null and !stun:
		vel = global_position.direction_to(Global.player.global_position)
	# calculate motion (normalized)
	var motion = vel.normalized() * speed
	move_and_slide(motion)

func _process(delta):
	if hp <= 0:
		sprite.play("hurt")
		if Global.node_creation_parent != null:
			var blood_instance = Global.instance_node(blood, global_position, Global.node_creation_parent)
			blood_instance.rotation = vel.angle()
		Global.score += 10
		queue_free()
	if stun:
		sprite.play("hurt")
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
	if area.is_in_group("enemy_damager"):
		$hitstun.start()
		sprite.play("hurt")
		modulate = Color(3,3,3)
		hp -= 10
		stun = true
		vel *= -8
		area.get_parent().queue_free()
		
func _on_hitstun_timeout():
	vel *= 0
	$pause.start()	
	
func _on_pause_timeout():
	modulate = Color("0058ff")
	stun = false;
