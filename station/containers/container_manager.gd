class_name ContainerManager
extends Node


@export var container_scene_array: Array[PackedScene]

@onready var world: Node3D = get_tree().get_first_node_in_group("World")

var container_instances_by_id: Dictionary[int, ShipContainer]

var is_switching: bool = false
var containers_initialized: bool = false

func _ready() -> void:
	# create the initial starting container
	var seed: ShipContainer = create_container(0)
	seed.stage()
	ManagerBus.world_manager.register_container_simple(seed)


func get_or_create_container(container_id: int) -> ShipContainer:
	if  container_instances_by_id.has(container_id) and container_instances_by_id[container_id]:
		return container_instances_by_id[container_id]
	return create_container(container_id)
	
func get_container_by_id(container_id: int) -> ShipContainer:
	if container_id:
		return container_instances_by_id[container_id]
	return null
	
	
func create_container(container_index: int) -> ShipContainer:
	if container_scene_array.is_empty():
		print("no scenes in the container scene array")
		return
	var container_instance: ShipContainer = container_scene_array.pick_random().instantiate()
	container_instance.container_id = container_index
	world.add_child(container_instance)
	container_instances_by_id[container_index] = container_instance
	return container_instance


func get_next_available_container(current_id: int) -> ShipContainer:
	var index: int = 0
	if current_id > 0:
		index = current_id
	var next_container: ShipContainer = null
	for i in range(index, container_scene_array.size()):
		if i in container_instances_by_id:
			if not ManagerBus.anchor_manager.is_container_anchored(i):
				next_container = container_instances_by_id[i]
				container_instances_by_id[i].stage()
				break
		else:
			next_container = get_or_create_container(i)
			break
	return next_container
