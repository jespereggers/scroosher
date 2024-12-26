extends AnimatedSprite2D

func _on_Explosion_animation_finished():
	queue_free()
