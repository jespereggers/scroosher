extends CharacterBody2D

var speed : = 90.0
var path : = PackedVector2Array() : set = set_path
signal BodyEntered(node)
signal FinishedPath()
var GunDregrees : Vector2 = Vector2(0,0)

func _ready() -> void:
	$Healthbar.value = Data.Enemies[name]["Health"]
	set_process(false)

func _process(delta: float) -> void:
	var move_distance : = speed * delta
	move_along_path(move_distance)
	$Gun.look_at(GunDregrees)


func move_along_path(distance: float) -> void:
	if self.position.distance_to(get_parent().get_node("Player").position) < get_viewport_rect().size.x/11:
		var start_point : = position
		for i in range(path.size()):
			if self.position.distance_to(path[path.size()-1]) > 25:
				var distance_to_next : = start_point.distance_to(path[0])
				if distance <= distance_to_next and distance >= 0.0:
					position = start_point.lerp(path[0], distance / distance_to_next)
					play_animation(start_point, path[0])
					break
				elif distance < 0.0:
					position = path[0]
					emit_signal("FinishedPath")
					#set_process(false)
					break
				distance -= distance_to_next
				start_point = path[0]
				path.remove(0)
				
func set_path(value: PackedVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)

func play_animation(start_point, next_point):
	var DistanceX = next_point.x - start_point.x
	var DistanceY = next_point.y - start_point.y
	if abs(DistanceX) > abs(DistanceY):
		if DistanceX > 0:
			$Texture2D.play("Right")
		if DistanceX < 0:
			$Texture2D.play("Left")
	else:
		if DistanceY > 0:
			$Texture2D.play("Down")
		if DistanceY < 0:
			$Texture2D.play("Top")
	return



func _on_Area2D_body_entered(body):
	emit_signal("BodyEntered", self)

func RenewHealth():
	if Data.Enemies[name]["Health"] > 3:
		Data.Enemies[name]["Health"] -= 3
		$Healthbar.value = Data.Enemies[name]["Health"]
	else:
		Data.Enemies.erase(name)
		queue_free()




func _on_GunDegrees_timeout():
	GunDregrees = get_parent().get_node("Player").position
