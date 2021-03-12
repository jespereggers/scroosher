extends Control
signal LeavePlanet

func _ready():
	Data.NextScene = "Space"

func _on_Leave_pressed():
	emit_signal("LeavePlanet")

func _input(_event):
	if Input.is_action_just_pressed("E"):
		emit_signal("LeavePlanet")
