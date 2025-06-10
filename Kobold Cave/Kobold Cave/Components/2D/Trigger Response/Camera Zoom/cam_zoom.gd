@tool
extends TriggerResponse
class_name TriggerCameraZoom
## zooms the camera when triggered
##
## ditto

var enter_zoom := Vector2.ONE
var enter_time := 1.25

var leave_zoom := Vector2.ONE
var leave_time := 1.25


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( editor_is_enter_callable() ):
		
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
	
	if ( editor_is_leave_callable() ):
		
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


func _player_enter( _player: Player ) -> void:
	
	KoboldUtility.set_camera_zoom_tween( enter_zoom, enter_time )

func _player_leave( _player: Player ) -> void:
	
	KoboldUtility.set_camera_zoom_tween( leave_zoom, leave_time )
