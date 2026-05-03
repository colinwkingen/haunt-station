class_name AnchorManager
extends Node

var all_anchors: Array[Anchor]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_anchors = get_all_anchors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_all_anchors() -> Array[Anchor]:
	if !all_anchors or all_anchors.is_empty():
		for child in get_tree().get_nodes_in_group("Anchor"):
				all_anchors.append(child)
	return all_anchors
	
func print_all_anchors() -> void:
	for anchor in get_all_anchors():
		print("----> anchor id %s has container id %s" % [anchor.anchor_id, anchor.container_id])

func is_container_anchored(container_id: int) -> bool:
	for anchor in get_all_anchors():
		#print("anchor id=%s has container id=%s" % [anchor.anchor_id, container_id])
		if anchor.container_id == container_id:
			return true
	return false
	
func get_anchor_with_id(anchor_id: int) -> Anchor:
	for anchor in get_all_anchors():
		if anchor.anchor_id == anchor_id:
			return anchor
	print("no anchor exists with id=%s" % anchor_id)
	return null
	
