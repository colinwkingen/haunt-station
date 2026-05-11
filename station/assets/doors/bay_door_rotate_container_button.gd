class_name RotateContainerButton
extends Node3D

@export var anchor_number: int
@export var forward: bool = true

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# every anchor is gonna need a unique id, so the rotate signals can be sent through the global 
# bus without conflicting

# ok now put this button as child of anchor, so it can derive it's id

func _on_generic_button_pressed() -> void:
		SignalBus.container_rotate_button_pressed(forward, anchor_number)
