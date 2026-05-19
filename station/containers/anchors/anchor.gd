class_name Anchor
extends Node3D


var anchor_id: int = -1
@export var anchor_name: String
@export var cardinal_direction: String
@export var anchor_data: ContainerAnchorData
var container_node: ShipContainer
var container_id: int
var is_switching: bool
# may not just be the previous int
#var last_container_id: int
var container_id_history: Array[int]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_id = ManagerBus.anchor_manager.register_anchor_and_get_id(self)
	if anchor_id == -1:
		print("error! got a -1 id for this anchor")
	cardinal_direction = get_anchor_cardinal_direction()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_container(container: ShipContainer):
	if container_id > 0:
		container_id_history.append(container_id)
	container_id = container.container_id
	container_node = container
	_set_container_location_to_anchor_location(container)
	
func get_anchor_cardinal_direction() -> String:
	if not cardinal_direction:
		var local_offset: Vector3 = position.normalized()
		match local_offset:
			Vector3.FORWARD:
				return "NORTH"
			Vector3.BACK:
				return "SOUTH"
			Vector3.LEFT:
				return "WEST"
			Vector3.RIGHT:
				return "EAST"
		return "ERR"
	return cardinal_direction
		

func _set_container_location_to_anchor_location(container: ShipContainer) -> void:
	var current_container: ShipContainer = owner
	var normalized_offset: Vector3 = position.normalized()
	var local_offset = container.container_width * normalized_offset
	var world_offset = local_offset + current_container.position
	container.set_position(world_offset)
	# hacktastic!
	container.rotation_degrees.y = [0, 90, 180, -90].pick_random()
	


func _is_container_spot_available() -> bool:
	# divide by the global width to get the grid units of the container.
	# the anchor is offset in the same direction we want to offset a new container
	var current_container: ShipContainer = owner
	var current_container_grid_coords = Vector3i(current_container.global_position / current_container.container_width)
	var adjacent_spot: Vector3i = current_container_grid_coords + Vector3i(position.normalized())
	return !ManagerBus.world_manager.is_location_occupied(adjacent_spot)

	
func dock_next_container() -> void:
	# don't do anything if world spot is occupied
	if !_is_container_spot_available():
		print("spot occupied, abort docking")
		return
	print("continuing with dock next container...")
	
	var container: ShipContainer = ManagerBus.container_manager.get_next_available_container(container_id)
	print("got next available container? : %s"%container)
	if container:
		if container_node:
			# unstage should remove from world grid
			container_node.unstage()
			container_id_history.append(container_id)
		
		set_container(container)
		ManagerBus.world_manager.register_container_simple(container)
		container.stage()
		

func dock_previous_container() -> void:
	if container_id_history.is_empty():
		return
	print("container id history: %s" % str(container_id_history))
		
	print("container id at -1: %s" % container_id_history[-1])
		
	var container: ShipContainer = ManagerBus.container_manager.get_container_by_id(container_id_history[-1])
	if container:
		container_id_history.pop_back()
		if container_node:
			container_node.unstage()
			container_id_history.append(container_id)
		set_container(container)
		container.stage()
	
	
func container_rotate_button_pressed(forward: bool) -> void:
	if is_switching:
		return
	is_switching = true
	var bay_door: Node3D
	for node in get_children():
		if node.is_in_group("BayDoor"):
			bay_door = node
	if !bay_door:
		is_switching = false
		return
	await bay_door.close_door_async()
	if forward:
		await dock_next_container()
	else:
		await dock_previous_container()
	# one frame wait, maybe not necessary
	# without it all actions are processed in one frame tho
	# await get_tree().process_frame
	#container_swap_finished.emit()
	await get_tree().create_timer(1.0).timeout
	await bay_door.open_door_async()
	is_switching = false
	
	
