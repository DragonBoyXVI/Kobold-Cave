@tool
extends TriggerResponse
class_name TriggerCameraBounds
## Sets the camera to be confined to a set of bounds
##
## ditto


var bounds_enter: Array[ CameraBoundry ] = []: 
	set( val ):
		
		bounds_enter = val
		update_configuration_warnings()
var bounds_leave: Array[ CameraBoundry ] = []: 
	set( val ):
		
		bounds_leave = val
		update_configuration_warnings()


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
			"hint_string": "%d/%d:CameraBoundry" % [TYPE_OBJECT, PROPERTY_HINT_NODE_TYPE]
		} )
	
	if ( editor_is_leave_callable() ):
		
		properties.append( {
			"name": "bounds_leave",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_ARRAY_TYPE,
			"hint_string": "%d/%d:CameraBoundry" % [TYPE_OBJECT, PROPERTY_HINT_NODE_TYPE]
		} )
	
	return properties

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( editor_is_enter_callable() ):
		if ( bounds_enter.is_empty() ):
			
			const text := "No bounds set for enter call. (save to rid message)"
			warnings.append( text )
	
	if ( editor_is_leave_callable() ):
		if ( bounds_leave.is_empty() ):
			
			const text := "No bounds set for leave call. (save to rid message)"
			warnings.append( text )
	
	return warnings

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"bounds_enter",
		"bounds_leave"
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		&"bounds_enter": return []
		&"bounds_leave": return []
	
	return null

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_EDITOR_PRE_SAVE:
			
			update_configuration_warnings()
			return
	
	super( what )


func _player_enter( _player: Player ) -> void:
	
	for bound: CameraBoundry in bounds_enter:
		
		bound.activate()

func _player_leave( _player: Player ) -> void:
	
	for bound: CameraBoundry in bounds_leave:
		
		bound.activate()


# for some reason, the nodes stored in the arrays get orphaned,
# so clean up here is needed. thanks godot
func _exit_tree() -> void:
	
	if ( Engine.is_editor_hint() ): return
	
	for item: Node in bounds_enter + bounds_leave:
		
		item.queue_free()
