@tool
extends PlayerState
class_name PlayerGrabbedLedge
##
##
##

const STATE_NAME := &"PlayerGrabbedLedge"


@export var ledge_grabber: LedgeGrabDetector :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		ledge_grabber = value


var ledge_info: LedgeGrabInfo


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not ledge_grabber ):
		
		const text := "GRABBER NEEDED AAAAAAAA"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	ledge_grabber.found_grab_ledge.connect( _on_ledge_found )


func _enter() -> void:
	
	request_state.call_deferred( PlayerAir.STATE_NAME )


func _on_ledge_found( _info: LedgeGrabInfo ) -> void:
	
	pass
