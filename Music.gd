extends Node

func Laser(pos):
	$Laser.position = pos
	$Laser.playing = true
	yield(get_tree().create_timer(0.46), "timeout")
	$Laser.playing = false
	
func Explosion(pos):
	$Explosion.position = pos
	$Explosion.playing = true
	yield(get_tree().create_timer(1.00), "timeout")
	$Explosion.playing = false

func _on_Theme_finished():
	$Theme.play()
