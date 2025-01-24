@tool
extends PlayerState
class_name PlayerGrabbedLedge
##
##
##

const STATE_NAME := &"PlayerGrabbedLedge"

const TILE_SIZE := Vector2( 128.0, 128.0 )
const PLAYER_OFFSET := Vector2( 100.0, 105.0 )


@export var ledge_grabber: LedgeGrabDetector :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		ledge_grabber = value


var grabbed_position: Vector2
var grabbed_right_side: bool


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
	
	#player.disable.call_deferred()
	#await get_tree().physics_frame
	#player.global_position = grabbed_position
	#return
	
	player.reset_physics_interpolation()
	player.velocity = Vector2.ZERO
	player.global_position.y = grabbed_position.y
	
	camera_focal.global_position = grabbed_position

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Move Up" ) ):
		
		player.logic_apply_jump(  )
		request_state( PlayerAir.STATE_NAME )
		
		get_window().set_input_as_handled()
		return 
	
	if ( event.is_action_pressed( &"Move Down" ) ):
		
		request_state( PlayerCrouched.STATE_NAME )
		
		get_window().set_input_as_handled()
		return


func _on_ledge_found( grab_position: Vector2, grab_right_side: bool ) -> void:
	
	grabbed_position = grab_position
	grabbed_right_side = grab_right_side
