extends KinematicBody2D

# 2D sprite
onready var sprite = $AnimatedSprite
onready var player = $AnimationPlayer
onready var smoke = $smokeFX
onready var current_color = sprite.modulate

# enemy speed and velocity vector
var alive = true
export(int) var speed = 20
var vel = Vector2(0, 0)

var stationary = false;

export(int) var hp = 100
export(int) var scoreValue = 0

#powerups
export(Array, PackedScene) var drops

func _ready():
	stationary = true
	sprite.play("idle")
	print("sup")
	player.play("entrance")

func _on_AnimationPlayer_animation_finished(anim_name):
	stationary = false;

func _physics_process(delta):
	# moves towards player
	if Global.player != null:
		vel = global_position.direction_to(Global.player.global_position)
	# calculate motion (normalized)
	if !stationary:
		var motion = vel.normalized() * speed
		move_and_slide(motion)
	
func _process(delta):
	# death
	if hp <= 0 and alive:
		visible = false
		alive = false
		sprite.play("hurt")
		$deathsound.play()
		#drops
		var random = round(rand_range(0, 3))
		if random == 0:
			var powerupPicker = round(rand_range(0, drops.size()-1))
			Global.instance_node(drops[powerupPicker], global_position, Global.node_creation_parent)
		
		# score increase
		scoreValue = 300-(OS.get_unix_time()-Global.boss_start_time)
		# score calculated by adding time seconds less than 5 minutes
		Global.score += scoreValue
		yield($deathsound, "finished")
		Global.win = true
		queue_free()
	# animation
	if !stationary:
		if vel[0] > 0:
			$AnimatedSprite.flip_h = false
			sprite.play("walk")
		elif vel[0] < 1:
			$AnimatedSprite.flip_h = true
			sprite.play("walk")
		elif vel[1] != 0:
			sprite.play("walk")
		else:		
			sprite.play("idle")		

func _on_hitbox_area_entered(area):
	# if contacted with bullet
	if area.is_in_group("enemy_damager"):
		$hitsound.play()
		sprite.play("hurt")
		hp -= 10
		area.get_parent().queue_free()

