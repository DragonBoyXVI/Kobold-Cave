
extends Node2D
class_name PooledNode2D
## pool
##
## poll


func enable() -> void:
	
	_enable()

func disable() -> void:
	
	_disable()

## Virtual
func _enable() -> void:
	pass

## Virtual
func _disable() -> void:
	pass
