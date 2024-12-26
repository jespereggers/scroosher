extends CharacterBody2D

var Speed = 100
var Velocity = Vector2()
var Player

func _ready():
	$Healthbar.value = Data.Inventory["Energy"]
	if get_tree().current_scene.get_name() == "Space":
		Player = get_node("Texture2D/Ships/Starter")
		get_node("Gun").show()
		Player.show()
	else:
		Player = get_node("Texture2D/Players/Norman")
		get_node("Gun").free()
		Player.show()
		
func movement():
	if Input.is_action_pressed("ui_shift"):
		Speed = 125
	else:
		Speed = 100
		
	if Input.is_action_pressed("ui_right"):
		Player.play("Right");
		Velocity.x += 1

	if Input.is_action_pressed("ui_left"):
		Player.play("Left");
		Velocity.x -= 1
			
	if Input.is_action_pressed("ui_up"):
		Player.play("Top");
		Velocity.y -= 1
			
	if Input.is_action_pressed("ui_down"):
		Player.play("Down");
		Velocity.y += 1

func _physics_process(_delta):
	movement()
	set_velocity(Velocity.normalized() * Speed)
	move_and_slide()
	Velocity = velocity
	Velocity = Vector2.ZERO 

func _on_Interface_HealthChanged():
	$Healthbar.value = Data.Inventory["Energy"]


func _on_SubstractTimer_timeout():
	if Data.Inventory["Energy"] > 0:
		Data.Inventory["Energy"] -= 5

func _on_Pause_pressed():
	if get_tree().current_scene.get_name() == "res://Space.tscn":
		Data.Position = position


func _on_Timer_timeout():
	$Healthbar.value = Data.Inventory["Energy"]
