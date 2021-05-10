extends "res://characters/zee.gd"

func _ready():
	Global.player = self
	Global.dead = false
	zee_sprite.play("idle")
	label.text = "right click to roll"
	animations.play("show_label")
