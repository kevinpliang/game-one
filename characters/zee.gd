extends KinematicBody2D

# 2D sprite
onready var zee_sprite = $ZeeSprite

# player speed and velocity vector
export var speed = 75
var vel = Vector2(0, 0)

func _ready():
	zee_sprite.play("idle")

func _physics_process(delta):
	# calculate velocity
	vel.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vel.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) / float(2)
	
	# calculate motion
	var motion = vel.normalized() * speed
	move_and_slide(motion)

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$ZeeSprite.flip_h = false
		zee_sprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		$ZeeSprite.flip_h = true
		zee_sprite.play("walk")
	elif Input.is_action_pressed("ui_down"):
		zee_sprite.play("walk")
	elif Input.is_action_pressed("ui_up"):
		zee_sprite.play("walk")
	else:		
		zee_sprite.play("idle")

