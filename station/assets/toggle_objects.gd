extends Node3D

@export var interact_objects: Array[Node]
@export var with_arg: bool
@export var with_named_method: bool
@export var named_method: String
@export var arg: String


func interact() -> void:
	var name = "interact"
	if with_named_method and named_method:
		name = named_method
	for ob in interact_objects:
		if ob and ob.has_method(name):
			if with_arg:
				ob.call(name, arg)
			else:
				print("calling with method name %s" % name)
				ob.call(name)
		else:
			print("attempted to toggle object without the target method")


func _on_generic_button_pressed() -> void:
	interact()
