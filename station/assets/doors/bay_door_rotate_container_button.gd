class_name RotateContainerButton
extends Node3D

@export var anchor_number: int
@export var button_increments: bool = true

var anchor_manager: AnchorManager
func _ready() -> void:
	anchor_manager = get_tree().get_first_node_in_group("AnchorManager")
	if not anchor_manager:
		print("no container manager, something is seriously wrong")
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cogito_button_pressed() -> void:
	var anchor = anchor_manager.get_anchor_with_id(anchor_number)
	if anchor:
		anchor.container_rotate_button_pressed(button_increments)
