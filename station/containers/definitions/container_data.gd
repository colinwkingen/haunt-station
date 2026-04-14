class_name ContainerData
extends Resource

# don't forget to add me to the container manager!

@export_category("State")
@export var opened: bool = false

@export_category("Attributes")
@export var container_name: String = "Mr. Container"
@export var container_scene: PackedScene
