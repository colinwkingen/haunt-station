class_name RotateContainerButton
extends Node3D

#@export var anchor_number: int
@export var forward: bool = true

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_parent_anchor_id() -> int:
	print("getting anchor number for button")
	if get_parent() is Anchor:
		print("parent is anchor")
		var parent_anchor: Anchor = get_parent()
		print("got anchor number %s"%parent_anchor.anchor_id)
		return parent_anchor.anchor_id
	return -1


func _on_generic_button_pressed() -> void:
		SignalBus.container_rotate_button_pressed(forward, _get_parent_anchor_id())
