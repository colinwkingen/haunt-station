class_name GlobalStationState
extends Node

signal update_bigboard(power: int, colors: String)


var anchor_manager: AnchorManager

var total_power: int = 0
# we say total because you can have multiples
var total_colors: Array[String]

var power_by_sector: Dictionary[String,int] = {
	"engineering": 0,
	"habitat": 0,
	"waste_processing": 0,
	"docking": 0,
	"operations": 0
}

# 1. Instead of separate power and colors, we will have power per color
# 2. Colors represent "sectors" Engineering, Habitat, Laboratory, Storage, Command
# 3. Containers are now PowerModules
# 4. Each sector will have PowerModules
# 5. Each sector has things consuming power
# 6. Doors now belong to a sector (one color), and require a minimum of power to that one sector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_manager = get_tree().get_first_node_in_group("AnchorManager")
	for anchor in anchor_manager.get_all_anchors():
		print("adding signals")
		anchor.add_docked_container_atts.connect(_add_container_atts)
		anchor.remove_docked_container_atts.connect(_remove_container_atts)
	# global station state owns bigboard, which displays state
	for node in get_tree().get_nodes_in_group("BigBoard"):
		var bigboard: BigBoard = node
		bigboard.initialize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _add_container_atts(container_data: ContainerData) -> void:
	total_power += container_data.power_level
	total_colors.append(container_data.color)
	update_bigboard.emit(total_power, get_colors_str())
	inform_doors_of_update()

func _remove_container_atts(container_data: ContainerData) -> void:
	total_power -= container_data.power_level
	total_colors.erase(container_data.color)
	update_bigboard.emit(total_power, get_colors_str())
	inform_doors_of_update()
	
func get_colors_str() -> String:
	var colors_str: String
	for color in total_colors:
		colors_str += "%s " % color
	return colors_str

func inform_doors_of_update() -> void:
	for node in get_tree().get_nodes_in_group("Doorway"):
		var doorway: Doorway = node
		if doorway.open_requirements_met(get_door_requirement_dict()):
			doorway.open_child_door()
		else:
			doorway.close_child_door()
	

func get_door_requirement_dict() -> Dictionary:
	return {
		"total_power": total_power,
		"total_colors": total_colors.duplicate()
	}
	
	
	
	
