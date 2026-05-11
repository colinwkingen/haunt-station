class_name PowerBreaker
extends Node3D


# should we have A/B/C states instead
@export var is_on: bool = true
@export var power_used: int = 1
# should we map power costs to multiple sectors
@export var sector: String = "ENGINEERING"

var global_station_state: GlobalStationState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_station_state = get_tree().get_first_node_in_group("GlobalStationState")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_breaker_switch_pressed() -> void:
	if is_on:
		SignalBus.breaker_flipped_emit(sector, power_used)
	else:
		SignalBus.breaker_flipped_emit(sector, -1 * power_used)
