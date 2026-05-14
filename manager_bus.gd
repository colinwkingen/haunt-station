extends Node

# can i just make a manager bus and onready all of these once?
@onready var world_manager: WorldManager = get_tree().get_first_node_in_group("WorldManager")
@onready var global_station_state: GlobalStationState = get_tree().get_first_node_in_group("GlobalStationState")
@onready var anchor_manager: AnchorManager = get_tree().get_first_node_in_group("AnchorManager")
@onready var container_manager: ContainerManager = get_tree().get_first_node_in_group("ContainerManager")

func _ready() -> void:
	print("loaded world_manager %s "%world_manager)
	print("loaded global_station_state %s "%global_station_state)
	print("loaded anchor_manager %s "%anchor_manager)
	print("loaded container_manager %s "%container_manager)
