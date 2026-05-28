class_name PowerBreaker
extends Node3D

@export var consumers: Array[Node3D]

# should we have A/B/C states instead
@export var is_on: bool = true
@export var power_used: int = 1
# should we map power costs to multiple sectors
@export var sector: String = "ENGINEERING"

#var global_station_state: GlobalStationState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_on_light_switch_flipped(is_on)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_on_light_switch_flipped(is_on: bool) -> void:
	self.is_on = is_on
	# on == green == more, so should SUBTRACT power from available pool
	if is_on:
		for node in consumers:
			if node.has_method("switch_on"):
				node.switch_on()
			else:
				print("this breaker stores a consumer without switch methods")
		SignalBus.breaker_flipped_emit(sector, -1 * power_used)
	else:
		for node in consumers:
			if node.has_method("switch_off"):
				node.switch_off()
			else:
				print("this breaker stores a consumer without switch methods")
		SignalBus.breaker_flipped_emit(sector, power_used)
