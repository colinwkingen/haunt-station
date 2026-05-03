class_name ContainerAnchorData
extends Resource


# this is a thin object we use for a "loading bay"
# the manager will keep track of each of these, and be able to
# shuffle containers around and through them and not need to care about spatial stuff

@export_category("Attributes")
@export var anchor_name: String
@export var anchor_id: int = -1
