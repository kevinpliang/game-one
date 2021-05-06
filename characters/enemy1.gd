extends "res://characters/enemyDefault.gd"

func _ready():
	sprite.play("idle")
 
func _physics_process(delta):
	basic_movement(delta)

func _process(delta):
	basic_process(delta)
