extends Node

func _on_Theme_finished():
	$Theme.play()

func PlayLaser(pos):
	var Laser = load("res://Audio/Laser.tscn").instantiate()
	Laser.position = pos
	add_child(Laser)
	await get_tree().create_timer(0.46).timeout
	get_node(Laser.get_name()).free()

func PlayExplosion(pos):
	var Explosion = load("res://Audio/Explosion.tscn").instantiate()
	Explosion.position = pos
	add_child(Explosion)
	await get_tree().create_timer(1.00).timeout
	get_node(Explosion.get_name()).free()
