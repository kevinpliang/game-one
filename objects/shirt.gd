extends AnimatedSprite

onready var zee2 = preload("res://characters/zee2.tscn")

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var zee = area.get_parent()
		Global.instance_node(zee2, area.global_position, Global.node_creation_parent)
		zee.queue_free()
		queue_free()

