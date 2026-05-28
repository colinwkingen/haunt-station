extends Node3D

# this class can be dropped on anthing that can be switched on and off
# it should be thin, and it's child nodes handle what switching on and off looks like

@export var consumer_nodes: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func switch_on() -> void:
	for node in consumer_nodes:
		node.show()


func switch_off() -> void:
	for node in consumer_nodes:
		node.hide()
