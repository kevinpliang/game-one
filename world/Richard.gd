extends KinematicBody2D

var canTalk = false

func _process(delta):
	pass

func _on_interactRange_area_entered(area):
	if area.is_in_group("player"):
		canTalk = true

func _on_interactRange_area_exited(area):
	if area.is_in_group("player"):
		canTalk = false
