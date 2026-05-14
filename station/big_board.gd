class_name BigBoard
extends Node3D

var world_coords: String

func _ready() -> void:
	initialize()
	
func initialize() -> void:
	ManagerBus.global_station_state.update_bigboard.connect(_update_power)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_coords(coords_str: String) -> void:
	#$BoardText.text = "Coords: %s \n%s" % [coords_str, $BoardText.text]
	world_coords = coords_str

func _update_power(power_by_sector: Dictionary[String,int]) -> void:
	var total_power: int
	for value in power_by_sector.values():
		total_power += value
	var board_update: String = "Coords: %s \n Total Power: %s\n" % [world_coords, total_power]
	for key in power_by_sector.keys():
		board_update += "%s: %s\n" % [key, power_by_sector[key]]
	$BoardText.text = board_update
