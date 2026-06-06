class_name ShipContainer
extends Node3D

var container_id: int

@export var container_width: int = 24

@export var power_level_upper_bound: int
@export var power_level_lower_bound: int
@export var power_level: int

#var SECTORS: Array[String] = ["DOCKING", "ENGINEERING", "HABITAT", "OPERATIONS", "WASTE_PROCESSING"]
@export_enum("DOCKING", "ENGINEERING", "HABITAT", "OPERATIONS", "WASTE_PROCESSING") var sector: String
@export var big_board: BigBoard

func _ready() -> void:
	power_level = randi_range(power_level_lower_bound,power_level_upper_bound)
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func unstage() -> void:
	visible = false
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	# go out of view, until we manage dequeueing undocked
	#ManagerBus.global_station_state.remove_container_atts(self)
	set_position(Vector3(1000,1000,1000))


func stage() -> void:
	visible = true
	set_process_mode(Node.PROCESS_MODE_INHERIT)
	#ManagerBus.global_station_state.add_container_atts(self)
	_label_big_board_with_coords()
	ManagerBus.global_station_state.refresh_sector_power()

	
func _label_big_board_with_coords() -> void:
	if big_board:
		big_board.update_coords(str(ManagerBus.world_manager.get_grid_position(self)))
		big_board.update_container_sector(sector)
