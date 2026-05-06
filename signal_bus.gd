extends Node



#signals that handle breakers and power consumers changing sector and global power levels
signal _breaker_flipped(sector: String, value: int)




func breaker_flipped_emit(sector: String, value: int) -> void:
	_breaker_flipped.emit(sector, value)
