extends Control

signal HealthChanged

func _ready():
	$RightCounter/Diamonds/Count.text = str(Data.Inventory["Diamonds"])
	$RightCounter/Glass/Count.text = str(Data.Inventory["Glass"])
	$RightCounter/Stone/Count.text = str(Data.Inventory["Stone"])
	$LeftCounter/Energy/Count.text = str(Data.Inventory["Energy"])
	$LeftCounter/Icon.texture = load("res://Textures/Icons/"+get_tree().current_scene.get_name().replace("res://","").replace(".tscn","")+".png")

func _input(_event):
	if Input.is_action_just_pressed("Esc"):
		$PauseMenu.visible = true
		get_tree().paused = true
		
func _on_SubstractHealth_timeout():
		emit_signal("HealthChanged")


func _on_Map_InventoryChanged(item):
	if item == "Energy":
		$LeftCounter/Energy/Count.text = str(Data.Inventory["Energy"])
	else:
		get_node("RightCounter/"+item+"/Count").text = str(Data.Inventory[item])


func _on_Title_pressed():
	#SAVE ENEMIES
	if get_tree().current_scene.get_name() == "Space":
		for node in get_parent().get_parent().get_children():
			if "Enemy" in node.get_name():
				Data.Enemies[node.get_name()]["Position"] = node.position
	
	if get_tree().current_scene.get_name() == "Space":
		Data.Position = get_parent().get_parent().get_node("Player").position
	else:
		Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"]["Position"] = get_parent().get_parent().get_node("Player").position
	
	Data.Save(get_tree().current_scene.get_name().replace("res://","").replace(".tscn",""))

	get_tree().paused = false
	get_tree().change_scene_to_file("res://Start.tscn")


func _on_Back_pressed():
	$PauseMenu.hide()
	get_tree().paused = false


func _on_Pause_pressed():
	$PauseMenu.popup()
	get_tree().paused = true


func _on_GameOver_pressed():
	Directory.new().remove("user://Save.sc")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Start.tscn")


func _on_Timer_timeout():
	$LeftCounter/Energy/Count.text = str(Data.Inventory["Energy"])
	
	if Data.Inventory["Energy"] <= 0:
			$GameOver.popup()
			get_tree().paused = true
