@tool
extends AreaTrigger2D
class_name TriggerCameraZoom
## sets the zoom of the camera
##
## ditto


var enter_zoom: Vector2 = Vector2.ONE
var enter_time: float = 1.25

var leave_zoom: Vector2 = Vector2.ONE
var leave_time: float = 1.25


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( run_enter ):
		
		properties.append( {
			"name": "Enter",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "enter_"
		} )
		
		properties.append( {
			"name": "enter_zoom",
			"type": TYPE_VECTOR2,
		} )
		
		properties.append( {
			"name": "enter_time",
			"type": TYPE_FLOAT,
		} )
	
	if ( run_leave ):
		
		properties.append( {
			"name": "Leave",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "leave_"
		} )
		
		properties.append( {
			"name": "leave_zoom",
			"type": TYPE_VECTOR2,
		} )
		
		properties.append( {
			"name": "leave_time",
			"type": TYPE_FLOAT,
		} )
	
	return properties

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"enter_time",
		"leave_time",
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		&"enter_time": return 1.25
		&"leave_time": return 1.25
	
	return null


func _player_entered( _player: Player ) -> void:
	
	MainCamera2D.set_zoom_tween( enter_zoom, enter_time )

func _player_left( _player: Player ) -> void:
	
	MainCamera2D.set_zoom_tween( leave_zoom, leave_time )
