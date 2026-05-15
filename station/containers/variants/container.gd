class_name ShipContainer
extends Node3D

@export var container_label: Label3D

var container_id: int

# the properties of the container should live in the container_data
# only logic goes in the container itself
@export var container_data: ContainerData
@export var container_width: int = 24
@export var indicator_light: OmniLight3D

@export var big_board: BigBoard

func _ready() -> void:
	if indicator_light:
		indicator_light.light_color = container_data.get_color_obj()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func unstage() -> void:
	visible = false
	set_process_mode(Node.PROCESS_MODE_DISABLED)
	# go out of view, until we manage dequeueing undocked
	ManagerBus.global_station_state.remove_container_atts(container_data)
	set_position(Vector3(100,100,100))

# this must be being called twice on NEW containers and not seed for the power to be doubled
func stage() -> void:
	print("stage called!!!")
	visible = true
	set_process_mode(Node.PROCESS_MODE_INHERIT)
	ManagerBus.global_station_state.add_container_atts(container_data)
	_label_big_board_with_coords()
	ManagerBus.global_station_state.refresh_sector_power()

# only fires when a container is swapped for an exisiting one
func set_container_data(data: ContainerData) -> void:
	print("-- triggered set_container_data()")
	container_data = data
	_generate_label()
	
# fires whenever a new container is created
func generate_container_data() -> void:
	container_data = ContainerData.new()
	# we are doing index and id? oops? equivalent?
	container_data.initialize(container_id)
	
# not used anymore?
func _generate_label() -> void:
	if container_label:
		container_label.text = ""
		_label_append_line("Name: ", container_data.container_name)
		_label_append_line("Color: ", container_data.sector)
		_label_append_line("Open State: ", container_data.get_open_str())
		_label_append_line("Power State: ", container_data.get_power_str())
		_label_append_line("Power Level: ", container_data.power_level)


func _label_append_line(key, value) -> void:
	#container_label.add_text(line)
	#container_label.newline()
	container_label.text += (key + str(value) + "\n")
	
func _label_big_board_with_coords() -> void:
	var big_board: BigBoard
	for child in get_children():
		if child is BigBoard:
			print("found bigboard")
			big_board = child
	big_board.update_coords(str(ManagerBus.world_manager.get_grid_position(self)))
