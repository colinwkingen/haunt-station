extends Node3D

@export var interact_objects: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func interact() -> void:
	for ob in interact_objects:
		if ob and ob.has_method("interact"):
			ob.interact()
		else:
			print("attempted to toggle object with no interact method")


func _on_generic_button_pressed() -> void:
	interact()
