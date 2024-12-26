extends RigidBody2D

var Explosion = preload("res://Explosion.tscn")
signal Collision(tile, body, pos)
signal PlayerGotShot()
signal EnemyGotShot(body)

func _on_Bullet_body_entered(body):
	if not body.is_in_group("Player") and not "Bullet" in body.get_name():
		if not "Enemy" in body.get_name() and body.get_cellv(body.local_to_map($Pivot.get_global_position())) != -1:
			PlayAnimation()
			emit_signal("Collision", Data.Translator["GetName"][body.get_name()][str(body.get_cellv(body.local_to_map($Pivot.get_global_position())))], body, body.local_to_map($Pivot.get_global_position()))
			queue_free()
	if "ByEnemy" in name and "Player" == body.get_name():
		PlayAnimation()
		
		emit_signal("PlayerGotShot")
		queue_free()
	if "ByPlayer" in name and "Enemy" in body.get_name():
		PlayAnimation()
		if get_parent().get_node("Space").has_node(body.get_name()):
			self.connect("EnemyGotShot",Callable(get_parent().get_node("Space").get_node(body.get_name()),"RenewHealth"))
			emit_signal("EnemyGotShot")
			queue_free()

func PlayAnimation():
	Audio.PlayExplosion(self.position)
	var ExplosionInstance = Explosion.instantiate()
	ExplosionInstance.position = get_global_position()
	get_tree().get_root().add_child(ExplosionInstance)
