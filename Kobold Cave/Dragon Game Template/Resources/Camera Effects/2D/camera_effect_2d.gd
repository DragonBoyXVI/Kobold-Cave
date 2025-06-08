@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
@tool
extends CameraEffectBase
class_name CameraEffect2D
## Base class for all camera2D effects
##
## This provides a base resource for all camera effects to stem from


## called by the camera when the effect is applied
func apply( cam: Camera2D ) -> void:
	
	_apply( cam )

## called by the camera when teh effect is removed
func remove( cam: Camera2D ) -> void:
	
	_remove( cam )

## called by the camera every frame to make relivant updates
func update( cam: Camera2D, delta: float ) -> void:
	
	_update( cam, delta )


func _apply( _cam: Camera2D ) -> void:
	pass

func _remove( _cam: Camera2D ) -> void:
	pass

func _update( _cam: Camera2D, _delta: float ) -> void:
	pass
