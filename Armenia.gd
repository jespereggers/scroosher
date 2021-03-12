extends Node2D

const WITH = 24
const HEIGHT = 14

var Sticker
var Position : Vector2

var LocalMap : Dictionary

func _ready():
	if not Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]].has("Surface"):
		$Player.position = Vector2(0,0)
	else:
		LoadSurface()
		$Player.position = Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"]["Position"]
	
	LocalMap = {"Ground": {"Gras_Block":[],"Ice_Block":[],"Sand_Block":[]},"Sticker":{"Gras_Block":[],"Ice_Block":[],"Sand_Block":[]}}
	
	Sticker = OpenSimplexNoise.new()
	Sticker.period = 10
	Sticker.persistence = 1
	Sticker.seed = int(rand_range(1,999))
	
	GenerateWorld()
	
func GenerateWorld():
	for x in WITH:
		for y in HEIGHT:
			if $Ground.get_cellv(Ground(x,y)) == -1:
				$Ground.set_cellv(Ground(x,y), Data.Translator["GetID"]["Ground"]["Ice_Block"])
				if Sticker.get_noise_2dv(Ground(x,y)) > 0.25:
					$Sticker.set_cellv(Ground(x,y), Data.Translator["GetID"]["Sticker"]["Ice_Block"])
					$Sticker.update_bitmask_area(Ground(x,y))

func Ground(x,y):
	Position = $Ground.world_to_map($Player.position)
	Position.x = int(Position.x-(x - WITH / 2))
	Position.y = int(Position.y-(y - HEIGHT / 2))
	return Position


func _on_Ticks_timeout():
	GenerateWorld()


func _on_LeavePlanet_LeavePlanet():
	SaveLocalMap()
	get_tree().change_scene("res://Space.tscn")

func SaveLocalMap():
	for pos in $Ground.get_used_cells():
		LocalMap["Ground"][Data.Translator["GetName"]["Ground"][str($Ground.get_cellv(pos))]].append(pos)
	for pos in $Sticker.get_used_cells():
		LocalMap["Sticker"][Data.Translator["GetName"]["Sticker"][str($Sticker.get_cellv(pos))]].append(pos)
	LocalMap["Position"] = $Player.position
	Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"] = LocalMap

func LoadSurface():
	for node in Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"]:
		if node == "Ground" or node == "Sticker": 
			for tile in Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"][node]:
				if Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"][node][tile] != []:
					for pos in Data.Map["Planets"][Data.LandingInfo["Planet"]][Data.LandingInfo["Position"]]["Surface"][node][tile]:
						get_node(node).set_cellv(pos, Data.Translator["GetID"][node][tile])
						$Sticker.update_bitmask_area(pos)

func _on_Title_pressed():
	SaveLocalMap()
