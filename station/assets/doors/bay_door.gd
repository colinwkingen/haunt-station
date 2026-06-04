extends Node3D

var start_position: Vector3
var target_position: Vector3
var duration: float
var is_open: bool = false
var is_moving: bool = false

@export var energy_cost: int = 1


signal opened
signal closed

func _ready() -> void:
	start_position = self.position
	target_position = start_position + Vector3(0, 3.125,0)
	duration = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func close_door_async() -> void:
	# goes to target from start
	if is_moving:
		await closed
		return
	if not is_open:
		closed.emit()
		return
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", start_position, duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	is_open = false
	is_moving = false
	closed.emit()
	
func open_door_async() -> void:
	# goes to start from target
	print("in open method")
	if is_moving:
		print("hit is moving")
		await opened
		return
	if is_open:
		print("hit is_open")
		opened.emit()
		return
	print("point 1")
	is_moving = true
	var tween = create_tween()
	print("point 2")
	tween.tween_property(self, "position", target_position, duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	print("point 3")
	await tween.finished
	is_open = true
	is_moving = false
	opened.emit()
	print("point 4")
	
func current_sector() -> String:
	var container: ShipContainer = owner
	return container.container_data.sector
	
func interact() -> void:
	var container: ShipContainer = owner
	if is_open:
		close_door_async()
		ManagerBus.global_station_state.update_sector_power(current_sector(), energy_cost)
	elif ManagerBus.global_station_state.can_reduce_power_by(energy_cost):
		open_door_async()
		ManagerBus.global_station_state.update_sector_power(current_sector(), -1 * energy_cost)
	
