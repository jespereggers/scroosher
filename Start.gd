extends Control

func _ready():
	$UI/Logo/AnimationPlayer.play("fly")
	if File.new().file_exists("user://Save.sc"):
		$UI/Planet.texture = load("res://Textures/Icons/"+GetScene().replace("res://","").replace(".tscn","") + "Mini.png")
	else:
		$UI/Planet.texture = load("res://Textures/Icons/Empty.png")
	if not File.new().file_exists("user://Save.sc"):
		$UI/Start.modulate.a8 = 50
		$UI/Planet.modulate.a8 = 50
		
func _on_Start_pressed():
	if File.new().file_exists("user://Save.sc"):
		Data.Load()
		get_tree().change_scene(GetScene())

func _on_New_pressed():
	Save()
	Data.Load()
	get_tree().change_scene("res://Space.tscn")

func Save():
	var content : Dictionary
	content["LandingInfo"] = {"Position":Vector2(0,0),"Planet": "Space"}
	content["Map"] = {"Planets":{"Orbis0":{},"Orbis1":{},"Orbis2":{},"Armenia0":{},"Armenia1":{},"Armenia2":{},"Palos0":{},"Palos1":{},"Palos2":{}},"Asteroids":{"Metroid0":{},"Metroid1":{},"Metroid2":{},"Empty":{}}}
	content["Position"] = Vector2(0,0)
	content["Inventory"] = {"Energy": 100,"Stone": 0, "Glass": 0, "Diamonds": 0}
	content["Enemies"] = {"Enemy0": {"Health": 100,"Position":Vector2(0,-100)}}
	var file = File.new()
	file.open("user://Save.sc", File.WRITE)
	file.store_var(content)
	file.close()
	
	content = {}

func _on_Close_pressed():
	get_tree().quit()

func GetScene():
	var file = File.new()
	file.open("user://Save.sc", File.READ)
	var content : Dictionary = file.get_var()
	file.close()
	if content["LandingInfo"]["Planet"] == "Space":
		return "res://Space.tscn"
	return "res://" + Data.Properties[content["LandingInfo"]["Planet"]]["Type"] + ".tscn"

func _on_YouTube_pressed():
	OS.shell_open("https://www.youtube.com/TakeLime")


func _on_DisableAudio_toggled(button_pressed):
	Audio.get_node("Theme").stream_paused = button_pressed
