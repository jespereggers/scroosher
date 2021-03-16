extends Node2D

var Bullet = preload("res://Bullet.tscn")
var CanFire = true
signal DeleteTile(tile, node, pos)
var speed = 5

func _process(delta):
	self.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("left_click") and CanFire:
		Audio.PlayLaser(get_parent().position)
		var BulletInstance = Bullet.instance()
		BulletInstance.position = $BulletPoint.get_global_position()
		BulletInstance.rotation_degrees = rotation_degrees
		BulletInstance.apply_impulse(Vector2(),Vector2(500, 0).rotated(rotation))
		BulletInstance.name += "ByPlayer"
		get_tree().get_root().add_child(BulletInstance)
		BulletInstance.add_to_group("Bullet", true)
		
		BulletInstance.connect("Collision", self, "GetCollision")
		
		CanFire = false
		yield(get_tree().create_timer(0.2), "timeout")
		CanFire = true


func GetCollision(tile, node, pos):
	if tile != "Empty" and Data.Map[node.get_name()][tile].has(pos):
		if Data.Map[node.get_name()][tile][pos]["Health"] < 5:
			Data.Map[node.get_name()][tile].erase(pos)
			emit_signal("DeleteTile", tile, node, pos)
		else:
			Data.Map[node.get_name()][tile][pos]["Health"] -= 5

