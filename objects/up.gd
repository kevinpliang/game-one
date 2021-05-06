extends AnimatedSprite

func _on_hitbox_area_entered(area):
	if area.is_in_group("player"):
		area.get_parent().fire_rate = 0.9*area.get_parent().fire_rate
		print(area.get_parent().fire_rate)
		queue_free()
