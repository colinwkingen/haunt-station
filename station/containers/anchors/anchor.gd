class_name Anchor
extends Node3D

signal add_docked_container_atts(container: ShipContainer)
signal remove_docked_container_atts(container: ShipContainer)

@export var anchor_id: int = -1
@export var anchor_name: String
@export var anchor_data: ContainerAnchorData
var container_node: ShipContainer
var container_id: int
var is_switching: bool
var container_manager: ContainerManager
var anchor_manager: AnchorManager
# may not just be the previous int
#var last_container_id: int
var container_id_history: Array[int]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container_manager = get_tree().get_first_node_in_group("ContainerManager")
	anchor_manager = get_tree().get_first_node_in_group("AnchorManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_container(container: ShipContainer):
	if container_id > 0:
		container_id_history.append(container_id)
	container_id = container.container_id
	container_node = container
	_set_container_location_to_anchor_location(container)
	

func _set_container_location_to_anchor_location(container: Node3D) -> void:
	container.set_position(get_position())
	
	
func dock_next_container() -> void:
	var container: ShipContainer = container_manager.get_next_available_container(container_id)
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
	#var anchor = anchor_manager.get_anchor_with_id(anchor_id)
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
	
	
