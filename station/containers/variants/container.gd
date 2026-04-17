class_name ShipContainer
extends Node3D

@export var container_name_label: Label3D

# just its in memory id
var container_id: int

var container_data: ContainerData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Variant owns only local behavior; manager owns placement and cycling.
func set_container_data(data: ContainerData) -> void:
	print("-- triggered set_container_data()")
	container_data = data
	
	container_name_label.text = container_data.container_name

#Variant owns only local behavior; manager owns placement and cycling.
