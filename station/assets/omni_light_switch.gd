class_name OmniLightSwitch
extends OmniLight3D

@export var is_on: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func switch_off() -> void:
	self.light_energy = 0

func switch_on() -> void:
	self.light_energy = 0.3


func _on_generic_button_pressed() -> void:
	is_on = !is_on
	if is_on:
		self.light_energy = 0.3
	else:
		self.light_energy = 0
