class_name ContainerManager
extends Node3D

signal container_swap_finished

@export var container_data_array: Array[ContainerData]

static var current_container_index: int = -1

static var is_switching: bool = false

# we should decouple these, to blueprints (data) and 
static var container_data_by_id: Dictionary[int, ContainerData]
static var container_instances_by_id: Dictionary[int, Node3D]

var containers_initialized: bool = false

func _ready() -> void:
	_initialize_containers()
	# we want to back away from the idea of "current container"
	# there should be many containers, some fixed and some generic.
	# an anchor starts with NO container, and rotating grabs the "next" one randomly.
	# we also keep track of "last" for a given anchor
	stage_current_container()
	set_current_container_to_anchor(1)

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
	

func stage_current_container() -> void:
	if current_container_index == -1 and num_container_data() > 0:
		current_container_index = 0
	print("current index: %s and container data size: %s " %\
	 	[current_container_index, num_container_data()])
	stage_container(current_container_index)

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
	
func unstage_current_container() -> void:
	if get_current_container():
		unstage_container(get_current_container())
	else:
		print("unstage_current_container: no current container was found")
		
func unstage_container(container: Node3D) -> void:
	if container:
		container.visible = false
		container.set_process_mode(Node.PROCESS_MODE_DISABLED)
		container.set_position(Vector3(100,100,100))
	else:
		print("unstage_container: no container was provided")
	
func get_current_container() -> Node3D:
	
	if container_instances_by_id.has(current_container_index):
		return container_instances_by_id[current_container_index]
	else:
		print("there is no current container")
	
	return get_or_create_container(current_container_index)

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
	
func set_current_container_to_anchor(anchor_id: int) -> void:
	if anchor_id == null:
		print("did not provide and anchor_id to set_current_container_to_anchor")
	if get_current_container():
		var anchor = get_anchor_by_id(anchor_id)
		if anchor:
			var container = get_current_container()
			anchor.container_node = container
			_set_container_location_to_anchor_location(container, anchor)
		else:
			print("no anchor with id %s could be found" % anchor_id)
	else:
		print("tried to set_current_container_to_anchor but there is no current_container")
	
func _set_container_location_to_anchor_location(container: Node3D, anchor: Node3D) -> void:
	container.set_position(anchor.get_position())

func rotate_containers(anchor_id: int) -> void:
	print("rotate is unstaging %s" % current_container_index)
	if get_current_container():
		unstage_container(get_current_container())
	if current_container_index < (num_container_data()-1):
		current_container_index +=1
	else: 
		current_container_index = 0
	
	print("with num_container_data=%s we are attempting to stage new index %s" % [num_container_data(), current_container_index])	
	
	stage_current_container()
	set_current_container_to_anchor(anchor_id)


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
