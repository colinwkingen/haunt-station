class_name WorldManager
extends Node

# The world manager doesn't care about containers, anchors or anything besides the
# occupied and unoccupied tiles of the world, and the world's boundries
# it could (should?) be unaware to the global scene size constraints

var world_grid: Dictionary[Vector3i, ShipContainer]


func register_container_simple(container: ShipContainer) -> void:
	var vect: Vector3i = get_grid_position(container)
	world_grid[vect] = container
	print("world manageer now indexes %s locations"%world_grid.keys().size())
	for key in world_grid.keys():
		print("loc at %s has the container %s"%[key, world_grid[vect]])
	
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
	



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
