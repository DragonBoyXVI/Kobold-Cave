@icon( "res://Dragon Game Template/Icons/States/state.png" )
extends Node
class_name State
## Base scene for anything related to states
##
## This class is used to create state machines, and behaviours for those
## state machines


## emitted when this is enabled
signal enabled
## emitted when this is disabled
signal disabled


## enables the node
func enable() -> void:
	
	_enable()
	enabled.emit()

## disables the node
func disable() -> void:
	
	_disable()
	disabled.emit()


## virtual for the enable function
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual for the disable function
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED
