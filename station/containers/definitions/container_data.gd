class_name ContainerData
extends Resource

# don't forget to add me to the container manager!

enum OPEN_STATE {OPEN, CLOSED}
enum POWER_STATE {ON,OFF,BROKEN}

var COLORS: Array[String] = ["RED", "YELLOW", "GREEN", "BLUE", "PURPLE"]

var power_max: int = 10

@export_category("State")
@export var opened: bool = false
@export var open_state: OPEN_STATE
@export var power_state: POWER_STATE
@export var color: String
@export var power_level: int

@export_category("Attributes")
@export var container_name: String = "Mr. Container"
@export var container_scene: PackedScene

func initialize(id: int) -> void:
	open_state = OPEN_STATE.values().pick_random()
	power_state = POWER_STATE.values().pick_random()
	color = COLORS.pick_random()
	container_name = container_name + " #%s" % id
	power_level = randi_range(0, power_max)
	
	
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
	match color:
		"BLUE":
			return Color.BLUE
		"RED":
			return Color.RED
		"YELLOW":
			return Color.YELLOW
		"GREEN":
			return Color.GREEN
		"PURPLE":
			return Color.PURPLE
	return Color.WHEAT
		
	
	
