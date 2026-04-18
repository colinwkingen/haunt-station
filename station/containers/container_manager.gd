class_name ContainerManager
extends Node3D

signal container_swap_finished

@export var container_data_array: Array[ContainerData]

var is_switching: bool = false
var container_data_by_id: Dictionary[int, ContainerData]
var container_instances_by_id: Dictionary[int, Node3D]
var containers_initialized: bool = false

var anchor_manager: AnchorManager

func _ready() -> void:
	anchor_manager = get_tree().get_first_node_in_group("AnchorManager")
	_initialize_containers()

func _initialize_containers() -> void:
	if containers_initialized:
		return
	# clear slate
	purge_containers()
	print("try init containers...")
	var container_count: int = 0
	for container_data in container_data_array:
		container_data_by_id[container_count] = container_data
		print("creating container  %s" % container_count)
		get_or_create_container(container_count)
		container_count +=1
	containers_initialized = true

func purge_containers() -> void:
	for key in container_instances_by_id.keys():
		if container_instances_by_id[key]:
			container_instances_by_id[key].queue_free()
	container_instances_by_id.clear()
	container_data_by_id.clear()
	

func get_or_create_container(container_id: int) -> ShipContainer:
	if  container_instances_by_id.has(container_id) and container_instances_by_id[container_id]:
		return container_instances_by_id[container_id]
	return create_container(container_id)
	
func create_container(container_index: int) -> ShipContainer:
	var container_data = container_data_by_id[container_index]
	if container_data:
		var container_instance = container_data.container_scene.instantiate()
		if container_instance.has_method("set_container_data"):
			container_instance.set_container_data(container_data)
			container_instance.container_id = container_index
			add_child(container_instance)
			unstage_container(container_instance)
			container_instances_by_id[container_index] = container_instance
			return container_instance
	else:
		# if no data, we should assign a data and container randomly
		print("no container data for index %s" % container_index)
	return null

func stage_container(container_index: int) -> void:
	var container = get_or_create_container(container_index)
	if container:
		container.visible = true
		container.set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		print("stage_container: no container was provided")
	
		
func unstage_container(container: Node3D) -> void:
	if container:
		container.visible = false
		container.set_process_mode(Node.PROCESS_MODE_DISABLED)
		container.set_position(Vector3(100,100,100))
	else:
		print("unstage_container: no container was provided")
	

func get_anchors() -> Array[Node]:
	var anchors = get_tree().get_nodes_in_group("Anchor")
	if not anchors or anchors.size() < 1:
		print("Something is weird.. Didn't find any container anchors!")
	return anchors
	
func get_anchor_by_id(target_id: int) -> Node:
	for anchor in get_anchors():
		if anchor.anchor_id == target_id:
			print("found anchor id %s, returning it" % target_id)
			return anchor
	print("failed to get anchor %s by id" % target_id)
	return null
	
func num_container_data() -> int:
	return container_data_by_id.keys().size()
	

# need to add stage last, and check already staged by other anchors

func rotate_containers(anchor_id: int) -> void:
	var anchor: Anchor = anchor_manager.get_anchor_with_id(anchor_id)
	if anchor.container_node:
		unstage_container(anchor.container_node)
	if anchor.container_id < (num_container_data()-1):
		anchor.container_id += 1
	else: 
		anchor.container_id = 0
	#print("with num_container_data=%s we are attempting to stage new index %s" % [num_container_data(), current_container_index])	
	var container: ShipContainer = get_or_create_container(anchor.container_id)
	stage_container(anchor.container_id)
	anchor.set_container(container)


func rotate_containers_async(anchor_id: int) -> void:
	rotate_containers(anchor_id)
	# one frame wait, maybe not necessary
	# without it all actions are processed in one frame tho
	await get_tree().process_frame
	container_swap_finished.emit()


func container_rotate_button_pressed(anchor_id: int) -> void:
	if is_switching:
		return
	is_switching = true
	var bay_door: Node3D
	var anchor = get_anchor_by_id(anchor_id)
	if not anchor:
		print("button press found no anchor for id=%s" % anchor_id)
		return
	for node in anchor.get_children():
		if node.is_in_group("BayDoor"):
			bay_door = node
	if !bay_door:
		is_switching = false
		return
	await bay_door.close_door_async()
	await rotate_containers_async(anchor_id)
	await get_tree().create_timer(1.0).timeout
	await bay_door.open_door_async()
	is_switching = false
