class_name ContainerManager
extends Node3D

# cant see it? look for the instance in main, dummy
@export var container_data_array: Array[ContainerData]

var current_container_index: int = -1
# the current container, the focus
var current_container_instance: Node3D
# all the currently spawned container instances
var container_instances: Array[Node3D] = []

#var anchors_by_id: Dictionary[int, Node3D]

var containers_initialized: bool = false

func _ready() -> void:
#Discover anchors from scene nodes (group or script type).
#Validate uniqueness of anchor_id.
#Instantiate containers from ContainerData.
#Initialize each instance with its data.
	_initialize_containers()
	stage_current_container()
	set_current_container_to_anchor(1)

func _initialize_containers() -> void:
	# we really only want the current one, and the one before and after in the array
	if containers_initialized:
		return
	# clear slate
	purge_containers()
	print("try init containers...")
	for container_data in container_data_array:
		print("- init containers found data")
		var container_instance = container_data.container_scene.instantiate()
		if container_instance.has_method("set_container_data"):
			container_instance.set_container_data(container_data)
			
			add_child(container_instance)
			unstage_container(container_instance)
			container_instances.append(container_instance)
	containers_initialized = true

func purge_containers() -> void:
	container_instances.clear()

func stage_current_container() -> void:
	if current_container_index == -1 and container_instances.size() > 0:
		current_container_index = 0
	print("current index: %s and instances size: %s " % [current_container_index, container_instances.size()])
	var container = container_instances[current_container_index]
	stage_container(container)
	
func stage_container(container: Node3D) -> void:
	if container:
		container.visible = true
		container.set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		print("stage_container: no container was provided")
	
func unstage_current_container() -> void:
	if get_current_container():
		var container = get_current_container()
		unstage_container(container)
	else:
		print("unstage_current_container: no current container was found")
		
func unstage_container(container: Node3D) -> void:
	if container:
		container.visible = false
		container.set_process_mode(Node.PROCESS_MODE_DISABLED)
	else:
		print("unstage_container: no container was provided")
	
func get_current_container() -> Node3D:
	return container_instances[current_container_index]


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
	
func set_current_container_to_anchor(anchor_id: int) -> void:
	if !anchor_id:
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

# rotation flow:
#current_container_index tracks active container.
#current_anchor_id tracks destination anchor.
#advance_container():
#Hide/disable previous.
#Compute next index.
#Move next instance to anchor transform.
#Show/enable next.
func rotate_containers() -> void:
	unstage_container(get_current_container())
	if current_container_index < container_instances.size():
		current_container_index +=1
	else: 
		current_container_index = 0
	stage_current_container()
	set_current_container_to_anchor(1)


# required:
#Every anchor node has unique anchor_id. +
#Every ContainerData has valid container_scene. +
#container_instances stores only instantiated nodes.
#get_anchor_by_id() returns nullable; caller handles null safely. +
#No Resource is treated as a spatial node. +

	



func _on_container_rotate_button_pressed() -> void:
	rotate_containers()
