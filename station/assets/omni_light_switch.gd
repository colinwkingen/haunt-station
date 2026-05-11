class_name OmniLightSwitch
extends OmniLight3D

@export var is_on: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_illumination()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_off() -> void:
	self.light_energy = 0

func switch_on() -> void:
	self.light_energy = 0.3

func _on_generic_button_pressed() -> void:
	is_on = !is_on
	set_illumination()
		
func set_illumination() -> void:
	if is_on:
		switch_on()
	else:
		switch_off()
		
