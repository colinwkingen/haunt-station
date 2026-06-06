class_name WorldManager
extends Node

# The world manager doesn't care about containers, anchors or anything besides the
# occupied and unoccupied tiles of the world, and the world's boundries
# it could (should?) be unaware to the global scene size constraints

var world_grid: Dictionary[Vector3i, ShipContainer]

func add_to_world(container_instance: ShipContainer) -> void:
	var world: Node3D = get_tree().get_first_node_in_group("World")
	world.add_child(container_instance)

func register_container_simple(container: ShipContainer) -> void:
	var vect: Vector3i = get_grid_position(container)
	world_grid[vect] = container
	print("world manageer now indexes %s locations"%world_grid.keys().size())
	for key in world_grid.keys():
		print("loc at %s has the container %s"%[key, world_grid[vect]])
	add_to_world(container)
	
# wire BigBoard to show each room coords
	
func is_location_occupied(vect: Vector3i) -> bool:
	if world_grid.has(vect) and world_grid[vect] != null:
		print("grid location %s already occupied"%vect)
		return true
	print("grid location %s is free"%vect)
	return false

func get_grid_position(container: ShipContainer) -> Vector3i:
	return Vector3i(container.global_position / container.container_width)

func num_locations() -> int:
	return world_grid.keys().size()
	
