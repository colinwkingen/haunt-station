class_name Anchor
extends Node3D

@export var anchor_id: int
@export var anchor_name: String
@export var anchor_data: ContainerAnchorData
var container_node: ShipContainer
var container_id: int
# may not just be the previous int
var last_container_id: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_container(container: ShipContainer):
	last_container_id = container_id
	container_id = container.container_id
	container_node = container
	
