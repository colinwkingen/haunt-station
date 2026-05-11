extends Node


#signals that handle breakers and power consumers changing sector and global power levels
signal _breaker_flipped(sector: String, value: int)

signal _container_rotate_button_pressed(forward: bool, anchor_number: int)



func breaker_flipped_emit(sector: String, value: int) -> void:
	_breaker_flipped.emit(sector, value)

func container_rotate_button_pressed(forward: bool, anchor_number: int) -> void:
	_container_rotate_button_pressed.emit(forward, anchor_number)
