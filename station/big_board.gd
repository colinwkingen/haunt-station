class_name BigBoard
extends Node3D

var global_station_state: GlobalStationState


func _ready() -> void:
	pass
	
func initialize() -> void:
	global_station_state = get_tree().get_first_node_in_group("GlobalStationState")
	global_station_state.update_bigboard.connect(_update_power)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_power(new_level: int, color_str: String) -> void:
	$BoardText.text = "Power: %s \n Colors: %s" % [new_level, color_str]
