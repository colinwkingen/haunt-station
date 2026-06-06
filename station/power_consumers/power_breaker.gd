class_name PowerBreaker
extends Node3D

@export var consumers: Array[Node3D]

# should we have A/B/C states instead
@export var is_on: bool = true
var power_level: int
# whether the sector type is of the container that owns it
@export var set_sector_to_parent: bool
@export var sector: String

@export var power_level_upper_bound: int
@export var power_level_lower_bound: int

@export var power_label: Label3D

#var global_station_state: GlobalStationState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("power level pre rand=%s" % power_level)
	power_level = randi_range(power_level_lower_bound, power_level_upper_bound)
	print("power level post rand=%s" % power_level)
	
	power_label.text = "%s%s" % [power_level, "⚡"]
	
	if set_sector_to_parent:
		var parent_container: ShipContainer = owner
		print("setting sector to parent sector %s" % parent_container.sector)
		sector = parent_container.sector
	if is_on:
		switch_on()
	else: 
		switch_off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_on_light_switch_flipped(is_on: bool) -> void:
	self.is_on = is_on
	print("switching %s breaker" % sector)
	if is_on:
		switch_on()
		SignalBus.breaker_flipped_emit(sector, -1 * power_level)
	else:
		switch_off()
		SignalBus.breaker_flipped_emit(sector, power_level)
		
		
func switch_on() -> void:
	for node in consumers:
		if node.has_method("switch_on"):
			node.switch_on()
		else:
			print("this breaker stores a consumer without switch methods")
			
func switch_off() -> void:
	for node in consumers:
		if node.has_method("switch_off"):
			node.switch_off()
		else:
			print("this breaker stores a consumer without switch methods")
