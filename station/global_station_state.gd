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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("_breaker_flipped", update_sector_power)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_container_atts(container: ShipContainer) -> void:
	print("adding container atts!!!")
	print("power level: %s sector: %s" % [container.power_level, container.sector ])
	total_power += container.power_level
	power_by_sector[container.sector] += container.power_level
	update_bigboard.emit(power_by_sector)
	SignalBus.update_hud(total_power)

func remove_container_atts(container: ShipContainer) -> void:
	total_power -= container.power_level
	power_by_sector[container.sector] -= container.power_level
	update_bigboard.emit(power_by_sector)
	SignalBus.update_hud(total_power)
	
	
func can_reduce_power_by(amount: int):
	return total_power - amount >= 0	

func update_sector_power(sector: String, value: int) -> void:
	print("update sector power!!!")
	power_by_sector[sector] += value
	total_power += value
	update_bigboard.emit(power_by_sector)
	SignalBus.update_hud(total_power)
	
func refresh_sector_power() -> void:
	update_bigboard.emit(power_by_sector)
	
