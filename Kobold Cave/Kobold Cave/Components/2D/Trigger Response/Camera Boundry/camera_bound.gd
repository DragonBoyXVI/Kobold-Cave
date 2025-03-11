@tool
extends TriggerResponse
class_name TriggerCameraBounds
## Sets the camera to be confined to a set of bounds
##
## ditto


var bounds_enter: Array[ CameraBoundry ] = []
var bounds_leave: Array[ CameraBoundry ] = []


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "Bounds",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "bounds_"
	} )
	
	if ( editor_is_enter_callable() ):
		
		properties.append( {
			"name": "bounds_enter",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_ARRAY_TYPE,
			"hint_string": "CameraBoundry"
		} )
	
	if ( editor_is_leave_callable() ):
		
		properties.append( {
			"name": "bounds_leave",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_ARRAY_TYPE,
			"hint_string": "CameraBoundry"
		} )
	
	return properties


func _player_enter( _player: Player ) -> void:
	
	for bound: CameraBoundry in bounds_enter:
		
		bound.activate()

func _player_leave( _player: Player ) -> void:
	
	for bound: CameraBoundry in bounds_leave:
		
		bound.activate()
