class_name Doorway
extends Node3D

# establish requirements for opening

@export var required_power: int
# it only makes sense to have one at this point, but we already built 
# it to allow multiple so why redo it
@export var required_sectors: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_requirements_met(current_state: Dictionary) -> bool:
	#print("open requirements check got current state: %s" % current_state)
	if current_state.total_power >= required_power:
		#print("power requirement met ..")
		for sector in required_sectors:
			sector.to_upper()
			if current_state.required_sectors.has(sector):
				current_state.required_sectors.erase(sector)
				return false
		return true
	return false

func open_child_door() -> void:
	for child in get_children():
		if child.is_in_group("SteelDoor"):
			var door: CogitoDoor = child
			door.open_door(null)
			
func close_child_door() -> void:
	for child in get_children():
		if child.is_in_group("SteelDoor"):
			var door: CogitoDoor = child
			door.close_door(null)
