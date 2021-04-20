extends KinematicBody2D

onready var zee_sprite = $ZeeSprite

func _ready():
	zee_sprite.play("idle")

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$ZeeSprite.flip_h = false
		zee_sprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		$ZeeSprite.flip_h = true
		zee_sprite.play("walk")
	else:		
		zee_sprite.play("idle")

