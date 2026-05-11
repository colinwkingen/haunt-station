class_name ContainerData
extends Resource

# don't forget to add me to the container manager!

enum OPEN_STATE {OPEN, CLOSED}
enum POWER_STATE {ON,OFF,BROKEN}

var SECTORS: Array[String] = ["DOCKING", "ENGINEERING", "HABITAT", "OPERATIONS", "WASTE_PROCESSING"]


var power_max: int = 25

@export_category("State")
@export var opened: bool = false
@export var open_state: OPEN_STATE
@export var power_state: POWER_STATE
@export var sector: String
@export var power_level: int = 1

@export_category("Attributes")
@export var container_name: String = "Power Module #"
# this is ROUGH. what is the side length of the smallest square the container gridmap
#could fit in, in meters
#@export var container_width: int

# the scene should have the data. the data does not need the scene, since it shouldn't
# be doing any businees 
#@export var container_scene: PackedScene

func initialize(id: int) -> void:
	open_state = OPEN_STATE.values().pick_random()
	power_state = POWER_STATE.values().pick_random()
	sector = SECTORS.pick_random()
	container_name = container_name + " #%s" % id
	
	
func get_power_str() -> String:
	match power_state:
		POWER_STATE.ON:
			return "On"
		POWER_STATE.OFF:
			return "Off"
		POWER_STATE.BROKEN:
			return "Broken"
	return "Error"
	
func get_open_str() -> String:
	match open_state:
		OPEN_STATE.OPEN:
			return "Open"
		OPEN_STATE.CLOSED:
			return "Closed"
	return "Error"
	
func get_color_obj() -> Color:
	match sector:
		"OPERATIONS":
			return Color.BLUE
		"DOCKING":
			return Color.RED
		"ENGINEERING":
			return Color.YELLOW
		"HABITAT":
			return Color.GREEN
		"WASTE_PROCESSING":
			return Color.PURPLE
	return Color.WHEAT
		
	
	
