class_name Anchor
extends Node3D

signal add_docked_container_atts(container: ShipContainer)
signal remove_docked_container_atts(container: ShipContainer)

var anchor_id: int = -1
@export var anchor_name: String
@export var cardinal_direction: String
@export var anchor_data: ContainerAnchorData
var container_node: ShipContainer
var container_id: int
var is_switching: bool
@onready var container_manager: ContainerManager = get_tree().get_first_node_in_group("ContainerManager")
@onready var anchor_manager: AnchorManager = get_tree().get_first_node_in_group("AnchorManager")
# may not just be the previous int
#var last_container_id: int
var container_id_history: Array[int]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_id = anchor_manager.register_anchor_and_get_id(self)
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

# actually this is shitty and we just need a world_manager to establish a grid for rooms
func _set_container_location_to_anchor_location(container: ShipContainer) -> void:
	#This is the local top node3d, the container
	var current_container = get_tree().get_first_node_in_group("Container")
	print("got current_container? %s"%current_container)
	print("got new container? : %s"%container)
	# this is the anchor's position from the origin of the container-
	# -1 or +1 on an axis
	var local_offset: Vector3 = position.normalized()
	print("new container width? %s"%container.container_width)
	# Transform local offset to world space using container's rotation
	print("local offset? %s"%local_offset)
	# since the other axis are zero, the hardcoded offset shoud tell
	# us where to place the new container, relative to the anchor
	var world_offset = container.container_width * local_offset
	print("world offset? %s"%world_offset)
	# Position new container as sibling with the offset applied
	container.set_position(world_offset)
	container.rotation = current_container.rotation
	
func dock_next_container() -> void:
	var container: ShipContainer = container_manager.get_next_available_container(container_id)
	print("got next available container? : %s"%container)
	if container:
		if container_node:
			remove_docked_container_atts.emit(container_node.container_data)
			container_node.unstage()
			container_id_history.append(container_id)
		set_container(container)
		add_docked_container_atts.emit(container_node.container_data)
		container.stage()
		

func dock_previous_container() -> void:
	if container_id_history.is_empty():
		return
	print("container id history: %s" % str(container_id_history))
		
	print("container id at -1: %s" % container_id_history[-1])
		
	var container: ShipContainer = container_manager.get_container_by_id(container_id_history[-1])
	if container:
		container_id_history.pop_back()
		if container_node:
			remove_docked_container_atts.emit(container_node.container_data)
			container_node.unstage()
			container_id_history.append(container_id)
		set_container(container)
		add_docked_container_atts.emit(container_node.container_data)
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
	
	
