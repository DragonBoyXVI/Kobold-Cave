@tool
extends Node
class_name Movement
## Base for movement components, not meant to be used on its own.
##
## ditto


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	return warnings

func _init() -> void:
	
	name = "Movement"
