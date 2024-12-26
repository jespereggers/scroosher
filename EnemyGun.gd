extends Node2D

var Bullet = preload("res://Bullet.tscn")
var CanFire = true
signal DeleteTile(tile, node, pos)

func _process(_delta):
	if get_parent().position.distance_to(get_parent().get_parent().get_node("Player").position) < get_viewport_rect().size.x/9:
		Shoot()

func Shoot():
	if CanFire == true:
		Audio.PlayLaser(get_parent().position)
		var BulletInstance = Bullet.instantiate()
		BulletInstance.position = $BulletPoint.get_global_position()
		BulletInstance.rotation_degrees = rotation_degrees
		BulletInstance.apply_impulse(Vector2(500, 0).rotated(rotation), Vector2())
		BulletInstance.name += "ByEnemy"
		get_tree().get_root().add_child(BulletInstance)
		BulletInstance.add_to_group("Bullet", true)
		
		BulletInstance.connect("Collision",Callable(self,"GetCollision"))
		BulletInstance.connect("PlayerGotShot",Callable(get_parent().get_parent().get_node("Player"),"_on_SubstractTimer_timeout"))
		CanFire = false

func GetCollision(tile, node, pos):
	if tile != "Empty" and Data.Map[node.get_name()][tile].has(pos):
		if Data.Map[node.get_name()][tile][pos]["Health"] < 5:
			Data.Map[node.get_name()][tile].erase(pos)
			emit_signal("DeleteTile", tile, node, pos)
		else:
			Data.Map[node.get_name()][tile][pos]["Health"] -= 5

func GetDamage():
	if get_parent().get_node("Healthbar").value > 5:
		get_parent().get_node("Healthbar").value -= 5
	else:
		queue_free()


func _on_Ticks_timeout():
	CanFire = true
