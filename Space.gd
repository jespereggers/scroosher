extends Node2D

var CurrentPlanet : Vector2
var pos : Vector2

signal CurrentPlanetChanged(CurrentPlanet)

onready var nav_2d : Navigation2D = $Map
onready var line_2d : Line2D = $Line
onready var Enemy : KinematicBody2D 

func _ready():
	$Player.position = Data.Position
	Data.LandingInfo["Planet"] = "Space"
	LoadEnemies()
	
func _input(event):
		
		
	if Input.is_action_just_pressed("E"):
		Data.Position = $Player.position
		
		if Data.NextScene != null:
			#SAVE ENEMIES
			for node in self.get_children():
				if "Enemy" in node.get_name():
					Data.Enemies[node.get_name()]["Position"] = node.position
			
			get_tree().change_scene("res://"+Data.NextScene+".tscn")

func NewCellEntered():
	if CurrentPlanet != $Map/Planets.world_to_map(get_global_mouse_position()):
		CurrentPlanet = $Map/Planets.world_to_map(get_global_mouse_position())
		emit_signal("CurrentPlanetChanged", CurrentPlanet)
	else:
		pass

func _on_Reload_timeout():
	NewCellEntered()

func GenerateEnemy(pos):
	var EnemyName = GetEnemyName()
	Enemy = load("res://Enemy.tscn").instance()
	Enemy.position = pos
	Data.Enemies[EnemyName] = {"Position": pos,"Health": 100}
	Enemy.set_name(EnemyName)
	self.add_child(Enemy)
	get_node(EnemyName).connect("BodyEntered", self, "GeneratePath")
	get_node(EnemyName).get_node("Gun").connect("DeleteTile", $Map, "_on_Gun_DeleteTile")

func GeneratePath(body):
	var new_path : = nav_2d.get_simple_path(body.global_position, $Player.position)
	line_2d.points = new_path
	body.path = new_path

func _on_Ticks_timeout():
	if Data.Enemies.keys().size() <= 2:
		if randi()%2+1 == 1:
			SpawnEnemies()
	else:
		if randi()%4+1 == 2:
			SpawnEnemies()

func LoadEnemies():
	for keys in Data.Enemies:
		Enemy = load("res://Enemy.tscn").instance()
		Enemy.position = Data.Enemies[keys]["Position"]
		Enemy.set_name(keys)
		self.add_child(Enemy)
		get_node(keys).connect("BodyEntered", self, "GeneratePath")
		get_node(keys).get_node("Gun").connect("DeleteTile", $Map, "_on_Gun_DeleteTile")

func SpawnEnemies():
	print("I like "+str(randi())+" cookies")
	pos.x = $Player.position.x + rand_range(-300, 300)
	pos.y = $Player.position.y + rand_range(-300, 300)
	if abs(pos.distance_to($Player.position)) > 100:
		GenerateEnemy(pos)

func GetEnemyName():
	if Data.Enemies.size() > 0:
		var Names : Array = []
		for value in Data.Enemies.keys():
			Names.append(int(value.replace("Enemy","")))
		return "Enemy"+str(Names.max()+1)
	else:
		return "Enemy1"
		
