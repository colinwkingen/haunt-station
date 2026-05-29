extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("_update_hud", update_global_power_display)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_global_power_display(power_int: int) -> void:
	var ticks: String
	for i in power_int:
		ticks += "|"
	var power_level: String = "Global Power: %s %s" % [power_int, ticks]
	$PowerLabel.text = str(power_level)
