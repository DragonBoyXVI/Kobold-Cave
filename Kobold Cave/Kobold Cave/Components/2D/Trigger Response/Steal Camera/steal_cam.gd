@tool
extends TriggerResponse
class_name TriggerStealCamera
## takes the camera and makes it look at something
##
## ditto


@export var marker: Marker2D


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not editor_is_enter_callable() ):
		
		const text := "Cant steal camera if enter isnt run"
		warnings.append( text )
	
	if ( not editor_is_leave_callable() ):
		
		const text := "If leave cant be called, the camera will be stuck here!"
		warnings.append( text )
	
	return warnings

func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Marker2D and not marker ):
		
		marker = node


func _player_enter( _player: Player ) -> void:
	
	if ( marker ):
		
		MainCamera2D.set_follow_node( marker )
	else:
		
		MainCamera2D.set_follow_node( self )

func _player_leave( _player: Player ) -> void:
	
	KoboldRadio.give_camera_to_player.emit()
