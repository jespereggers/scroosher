extends Node2D

const WITH = 24
const HEIGHT = 14

var Position : Vector2
var Space
var Planets = ["Orbis", "Armenia", "Palos"]
var Planet
var Digit

signal InventoryChanged(item)

func _ready():
	
	LoadSpace()
	
	Space = OpenSimplexNoise.new()
	Space.period = 10
	Space.persistence = 1
	Space.seed = int(randf_range(1,999))
	
	GenerateWorld()
	
	
func GenerateWorld():
	for x in WITH:
		for y in HEIGHT:
			if $Asteroids.get_cellv(Asteroid(x,y)) == -1 and $Planets.get_cellv(Planet(x,y)) == -1:
				GenerateSpace(x,y)


func Asteroid(x,y):
	Position = $Asteroids.local_to_map(get_parent().get_node("Player").position)
	Position.x = int(Position.x-(x - WITH / 2))
	Position.y = int(Position.y-(y - HEIGHT / 2))
	return Position

func Planet(x,y):
	Position = $Planets.local_to_map(get_parent().get_node("Player").position)
	Position.x = int(Position.x-(x - WITH / 2))
	Position.y = int(Position.y-(y - HEIGHT / 2))
	return Position

func GenerateSpace(x,y):
	Digit = str(int(randf_range(0,3)))
	if randi()%1000+1 > 995:
		Planet = str(Planets[int(randf_range(0,3))])
		$Planets.set_cellv(Planet(x,y), Data.Translator["GetID"]["Planets"][Planet + Digit])
		Data.Map["Planets"][Planet+Digit][Planet(x,y)] = {"Health": Data.Permissions[Planet]["Health"]}
	elif randi()%1000+1 > 980:
		$Asteroids.set_cellv(Asteroid(x,y), Data.Translator["GetID"]["Asteroids"]["Metroid" + Digit])
		Data.Map["Asteroids"]["Metroid"+Digit][Asteroid(x,y)] = {"Health": Data.Permissions["Metroid"]["Health"]}
	else:
		$Asteroids.set_cellv(Asteroid(x,y), Data.Translator["GetID"]["Asteroids"]["Empty"])
		Data.Map["Asteroids"]["Empty"][Asteroid(x,y)] = {}

	
		
func _on_Reload_timeout():
	GenerateWorld()

func _on_Gun_DeleteTile(tile, node, pos):
	get_node(node.get_name()).set_cellv(pos, -1)
	LoadContext($Planets.local_to_map(get_global_mouse_position()))
	
	for loot in Data.Permissions[Data.Properties[tile]["Type"]]["Loot"]:
		Data.Inventory[loot] += int(randf_range(Data.Permissions[Data.Properties[tile]["Type"]]["Loot"][loot]["min"], Data.Permissions[Data.Properties[tile]["Type"]]["Loot"][loot]["max"]))
		if Data.Inventory[loot] > 999:
			Data.Inventory[loot] = 999
		emit_signal("InventoryChanged",loot)

func _on_Space_CurrentPlanetChanged(CurrentPlanet):
	LoadContext(CurrentPlanet)

func LoadContext(CurrentPlanet):
	if $Planets.get_cellv(CurrentPlanet) != -1:
		Data.NextScene = Data.Properties[Data.Translator["GetName"]["Planets"][str($Planets.get_cellv(CurrentPlanet))]]["Type"]
		$Land.position.x = $Planets.map_to_local(CurrentPlanet).x + 16
		$Land.position.y = $Planets.map_to_local(CurrentPlanet).y + 16
		Data.LandingInfo = {"Position":CurrentPlanet,"Planet":Data.Translator["GetName"]["Planets"][str($Planets.get_cellv(CurrentPlanet))]}
		$Land.show()
		return
	else:
		$Land.hide()
		Data.NextScene = null

func LoadSpace():
	for node in Data.Map:
		if node == "Asteroids" or node == "Planets": 
			for tile in Data.Map[node]:
				if Data.Map[node][tile] != {}:
					for pos in Data.Map[node][tile]:
						get_node(node).set_cellv(pos, Data.Translator["GetID"][node][tile])
