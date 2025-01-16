@tool
extends ScalieResource
class_name CameraEffect2D
## Base class for all camera2D effects
##
## This provides a base resource for all camera effects to stem from


signal applied
signal removed
signal updated


## what duration mode to use
enum DURATION_MODE {
	## disapear after some time
	LIMITED,
	## never disapear
	UNLIMITED
}


@export_group( "Duration", "duration_" )
## the duration mode to use
@export var duration_mode: DURATION_MODE :
	set( value ):
		notify_property_list_changed.call_deferred()
		
		duration_mode = value

## the max time this can last
var duration_max: float = 1.25
## how long the effect has been in place
var duration_current: float = 0.0
## % of time passed
var duration_percent: float = 0.0


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( duration_mode == DURATION_MODE.LIMITED ):
		
		properties.append( {
			"name": "duration_max",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0.0,25.0,0.01,or_greater"
		} )
	
	return properties

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"duration_max"
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		
		&"duration_max": return 1.25
	
	return null


## called by camera to increase this effects time.
## returns true when the effect has expired
func tick_duration( delta: float ) -> bool:
	
	duration_current += delta
	duration_percent = ( duration_current / duration_max )
	if ( duration_mode == DURATION_MODE.LIMITED ):
		
		return ( duration_current >= duration_max )
	
	return false

## call to reset the timer.
## you should just pass a dupe to avoid ref hell but you do you
func reset() -> void:
	
	duration_current = 0.0
	duration_percent = 0.0


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
