class_name ShipContainer
extends Node3D

@export var container_label: Label3D

var container_id: int

var container_data: ContainerData

@export var indicator_light: OmniLight3D

func _ready() -> void:
	indicator_light.light_color = container_data.get_color_obj()
	
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func unstage() -> void:
	visible = false
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	# go out of view, until we manage dequeueing undocked
	set_position(Vector3(100,100,100))
	
func stage() -> void:
	visible = true
	set_process_mode(Node.PROCESS_MODE_INHERIT)

#Variant owns only local behavior; manager owns placement and cycling.
func set_container_data(data: ContainerData) -> void:
	print("-- triggered set_container_data()")
	container_data = data
	_generate_label()
	

func _generate_label() -> void:
	container_label.text = ""
	_label_append_line("Name: ", container_data.container_name)
	_label_append_line("Color: ", container_data.color)
	_label_append_line("Open State: ", container_data.get_open_str())
	_label_append_line("Power State: ", container_data.get_power_str())
	_label_append_line("Power Level: ", container_data.power_level)


func _label_append_line(key, value) -> void:
	#container_label.add_text(line)
	#container_label.newline()
	# str for mah ints
	container_label.text += (key + str(value) + "\n")
	
