extends Node3D

var start_position: Vector3
var target_position: Vector3
var duration: float
var is_open: bool = true
var is_moving: bool = false

signal opened
signal closed

func _ready() -> void:
	start_position = self.position
	target_position = start_position + Vector3(0,-3.125,0)
	duration = 3.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func close_door_async() -> void:
	if is_moving:
		await closed
		return
	if not is_open:
		closed.emit()
		return
	is_moving = true
	print("closing door..")
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	is_open = false
	is_moving = false
	closed.emit()
	
func open_door_async() -> void:
	if is_moving:
		await opened
		return
	if is_open:
		opened.emit()
		return
	is_moving = true
	print("opening door..")
	var tween = create_tween()
	tween.tween_property(self, "position", start_position, duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	is_open = true
	is_moving = false
	opened.emit()
	
