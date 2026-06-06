extends Node3D

@export var target_anchor: Anchor
@export var room_description: Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# heh, you could just have a signal and have anchor listen for it

func next_room() -> void:
	if target_anchor:
		target_anchor.next_room()
		update_description()
	
func previous_room() -> void:
	if target_anchor:
		target_anchor.previous_room()
		update_description()

func lock_in_room() -> void:
	if target_anchor:
		target_anchor.lock_in_room()
		update_description()
		
		# uh, call this
func update_description() -> void:
	if  target_anchor.container_node:
		var sector_locked: String = target_anchor.container_node.sector
		room_description.text = "%s %s" % [sector_locked, "🔒"]
		room_description.modulate = Color.RED
	elif target_anchor.temp_container_node:
		var sector_temp: String = target_anchor.temp_container_node.sector
		room_description.text = "%s %s" % [sector_temp, "🔓"]
		room_description.modulate = Color.GREEN
	else:
		room_description.text = "ERR"
		room_description.modulate = Color.PURPLE
