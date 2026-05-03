class_name ContainerManager
extends Node

#signal container_swap_finished

# this should contain all the possible container scenes, i.e. the models
@export var container_scenes: Array[PackedScene]
@export var max_containers: int = 10

var is_switching: bool = false
var container_data_array: Array[ContainerData]
var container_data_by_id: Dictionary[int, ContainerData]
var container_instances_by_id: Dictionary[int, ShipContainer]
var containers_initialized: bool = false
var anchor_manager: AnchorManager

func _ready() -> void:
	anchor_manager = get_tree().get_first_node_in_group("AnchorManager")


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
	
func get_container_by_id(container_id: int) -> ShipContainer:
	if container_id:
		return container_instances_by_id[container_id]
	return null
	
	
func create_container(container_index: int) -> ShipContainer:
	var container_data: ContainerData
	if container_data_by_id.keys().has(container_index):
		container_data = container_data_by_id[container_index]
	
	if not container_data:
		container_data = ContainerData.new()
		container_data.container_scene = container_scenes.pick_random()
		container_data.initialize(container_index)
		container_data_by_id[container_index] = container_data
	
	var container_instance: ShipContainer = container_data.container_scene.instantiate()
	if container_instance.has_method("set_container_data"):
		container_instance.set_container_data(container_data)
		container_instance.container_id = container_index
		add_child(container_instance)
		container_instance.unstage()
		container_instances_by_id[container_index] = container_instance
	return container_instance

			
func print_all_containers() -> void:
	for i in container_instances_by_id.keys():
		var is_in_arr: bool = i in container_instances_by_id
		var is_anchored: bool = anchor_manager.is_container_anchored(i)
		print("container id=%s is in arr=%s and is anchored=%s" % [i, is_in_arr, is_anchored])
		
	
func below_container_max() -> bool:
	var existing: int = 0
	for key in container_instances_by_id.keys():
		if container_instances_by_id[key]:
			existing +=1
	return existing <= max_containers
	
	
# need to get that array wrap when we hit max
	
func get_next_available_container(current_id: int) -> ShipContainer:
	var index: int = 0
	if current_id > 0:
		index = current_id
	var next_container: ShipContainer = null
	for i in range(index, max_containers):
		if i in container_instances_by_id:
			if not anchor_manager.is_container_anchored(i):
				next_container = container_instances_by_id[i]
				container_instances_by_id[i].stage()
				break
		else:
			next_container = get_or_create_container(i)
			break
	return next_container
