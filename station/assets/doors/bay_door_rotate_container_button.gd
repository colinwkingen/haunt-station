class_name RotateContainerButton
extends Node3D

@export var anchor_number: int

var container_manager: ContainerManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container_manager = get_tree().get_first_node_in_group("ContainerManager")
	if not container_manager:
		print("no container manager, something is seriously wrong")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cogito_button_pressed() -> void:
	container_manager.container_rotate_button_pressed(anchor_number)
