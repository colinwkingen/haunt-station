class_name AnchorManager
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_all_anchors() -> Array[Anchor]:
	var anchors: Array[Anchor]
	for child in get_children():
		if child.is_in_group("Anchor"):
			anchors.append(child)
	return anchors

func is_container_anchored(container_id: int) -> bool:
	for anchor in get_all_anchors():
		if anchor.container_id == container_id:
			return true
	return false
	
func get_anchor_with_id(anchor_id: int) -> Anchor:
	for anchor in get_all_anchors():
		if anchor.anchor_id == anchor_id:
			return anchor
	print("no anchor exists with id=%s" % anchor_id)
	return null
	
