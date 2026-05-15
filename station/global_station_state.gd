class_name GlobalStationState
extends Node

signal update_bigboard(power_by_sector: Dictionary)


var anchor_manager: AnchorManager

var total_power: int = 0
# we say total because you can have multiples
var total_colors: Array[String]

var power_by_sector: Dictionary[String,int] = {
	"ENGINEERING": 0, # Yellow
	"HABITAT": 0, # Green
	"WASTE_PROCESSING": 0, # Purple
	"DOCKING": 0, # Red
	"OPERATIONS": 0 # Blue
}

# 1. Instead of separate power and colors, we will have power per color
# 2. Colors represent "sectors" Engineering, Habitat, Laboratory, Storage, Command
# 3. Containers are now PowerModules
# 4. Each sector will have PowerModules
# 5. Each sector has things consuming power
# 6. Doors now belong to a sector (one color), and require a minimum of power to that one sector


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("_breaker_flipped", update_sector_power)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_container_atts(container_data: ContainerData) -> void:
	print("adding container atts!!!")
	
	print("power level: %s sector: %s" % [container_data.power_level, container_data.sector ])
	
	total_power += container_data.power_level
	#total_colors.append(container_data.sector)
	
	power_by_sector[container_data.sector] += container_data.power_level
	
	update_bigboard.emit(power_by_sector)
	inform_doors_of_update()

func remove_container_atts(container_data: ContainerData) -> void:
	total_power -= container_data.power_level
	#total_colors.erase(container_data.color)
	
	power_by_sector[container_data.sector] -= container_data.power_level
	
	update_bigboard.emit(power_by_sector)
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
	

func update_sector_power(sector: String, value: int) -> void:
	print("update sector power!!!")
	power_by_sector[sector] += value
	inform_doors_of_update()
	update_bigboard.emit(power_by_sector)
	
func refresh_sector_power() -> void:
	update_bigboard.emit(power_by_sector)
	
