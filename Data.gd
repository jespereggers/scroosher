extends Node

var Translator
var Properties
var Permissions

var NextScene
var LandingInfo

var file
var content : Dictionary

var CurrentScene : String
var Map : Dictionary
var Inventory : Dictionary
var Position : Vector2
var Enemies : Dictionary

func _ready():

	file = File.new()
	file.open("res://Data/Translator.json", File.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text()).result
	Translator = test_json_conv.get_data()
	file.close()
	
	file = File.new()
	file.open("res://Data/Properties.json", File.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text()).result
	Properties = test_json_conv.get_data()
	file.close()
	
	file = File.new()
	file.open("res://Data/Permissions.json", File.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text()).result
	Permissions = test_json_conv.get_data()
	file.close()


func Load():
	file = File.new()
	file.open("user://Save.sc", File.READ)
	var content : Dictionary = file.get_var()
	file.close()

	LandingInfo = content["LandingInfo"]
	Map = content["Map"]
	Position = content["Position"]
	Inventory = content["Inventory"]
	Enemies = content["Enemies"]
	
	content = {}

func Save(Scene):
	if Scene == "Space":
		LandingInfo["Planet"] = "Space"
	content["LandingInfo"] = LandingInfo
	content["Map"] = Map
	content["Position"] = Position
	content["Inventory"] = Inventory
	content["Enemies"] = Enemies
	
	file = File.new()
	file.open("user://Save.sc", File.WRITE)
	file.store_var(content)
	file.close()
