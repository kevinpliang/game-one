extends AnimatedSprite

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var zee = area.get_parent()
		zee.label.text = "fire rate up"
		zee.animations.queue("show_label")
		zee.fire_rate = 0.9*area.get_parent().fire_rate
		queue_free()
