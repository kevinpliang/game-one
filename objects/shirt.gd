extends AnimatedSprite

onready var zee2 = preload("res://characters/zee2.tscn")

func _on_Area2D_area_entered(area):
	if area.is_in_group("player") and !Global.ish_mode:
		var zee = area.get_parent()
		var zee_pos = area.global_position
		zee.queue_free()
		Global.zee = 2
		Global.instance_node(zee2, zee_pos, Global.node_creation_parent)		
		queue_free()
	elif area.is_in_group("player") and Global.ish_mode:
		var ish = area.get_parent()
		randomize()
		var choose_text = round(rand_range(0, 1))
		var choices = ["so ugly", "dodging sucks"]
		if !ish.animations.is_playing():
			ish.label.text = choices[choose_text]
			ish.animations.queue("show_label")

