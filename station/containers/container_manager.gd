class_name ContainerManager
extends Node


@export var container_scene_array: Array[PackedScene]
var container_scenes_by_id: Dictionary[int,PackedScene]

var container_instances_by_id: Dictionary[int, ShipContainer]

var is_switching: bool = false

func _ready() -> void:
	for scene in container_scene_array:
		container_scenes_by_id[container_scene_array.find(scene)] = scene	
	# create the initial starting container
	var seed: ShipContainer = create_random_container(0)
	seed.stage()
	ManagerBus.world_manager.register_container_simple(seed)


#func get_or_create_container(container_id: int) -> ShipContainer:
	#if  container_instances_by_id.has(container_id) and container_instances_by_id[container_id]:
		#return container_instances_by_id[container_id]
	#return create_container(container_id)
	#
#func get_container_by_id(container_id: int) -> ShipContainer:
	#if container_id:
		#return container_instances_by_id[container_id]
	#return null
	#
	#
func create_random_container(container_index: int) -> ShipContainer:
	if container_scene_array.is_empty():
		print("no scenes in the container scene array")
		return
	var container_instance: ShipContainer = container_scene_array.pick_random().instantiate()
	container_instance.container_id = container_index
	container_instances_by_id[container_index] = container_instance
	return container_instance

#
#func get_next_available_container(current_id: int) -> ShipContainer:
	#var index: int = 0
	#if current_id > 0:
		#index = current_id
	#var next_container: ShipContainer = null
	#for i in range(index, container_scene_array.size()):
		#if i in container_instances_by_id:
			#if not ManagerBus.anchor_manager.is_container_anchored(i):
				#next_container = container_instances_by_id[i]
				#container_instances_by_id[i].stage()
				#break
		#else:
			#next_container = get_or_create_container(i)
			#break
	#return next_container
	
	
	##########################
	# there is an array of N container scenes
	# each of them can be instantiated, and becomes a container
	# each anchor stores it's container ID
	# the manager tracks the containers for each id
	
#func get_next_container_option(index: int) -> ShipContainer:
	#return container_scene_array.get(index).instantiate()
	##
#func get_next_container_id() -> int:
	#return container_instances_by_id.keys().size()
	#
#func get_container_options(anchor: Anchor) -> Array[ShipContainer]:
	#var options: Array[ShipContainer]
	#for scene in container_scene_array:
		#var room: ShipContainer = scene.instantiate()
		#if anchor.can_dock_container(room):
			#options.append(room)
	#return options
	#
	
func get_scene_by_index(index: int) -> PackedScene:
	return container_scenes_by_id[index] 
	
func get_num_scenes() -> int:
	return container_scene_array.size()
