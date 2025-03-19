@tool
extends PlayerState
class_name PlayerGrabbedLedge
##
##
##

const STATE_NAME := &"PlayerGrabbedLedge"

const TILE_SIZE := Vector2( 128.0, 128.0 )
const PLAYER_OFFSET := Vector2( 100.0, 105.0 )


const ARG_GRAB_POSITION := &"Grab Position"
const ARG_GRAB_RIGHT := &"Grab Right"

var grab_position: Vector2
var grab_right_side: bool


func _enter( args: Dictionary ) -> void:
	
	grab_position = args[ ARG_GRAB_POSITION ]
	grab_right_side = args[ ARG_GRAB_RIGHT ]
	
	camera_focal.global_position = grab_position

func _physics_process( _delta: float ) -> void:
	
	if ( player.velocity.length_squared() > 0.0 ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		player.logic_apply_jump(  )
		request_state( PlayerAir.STATE_NAME )
		
		get_window().set_input_as_handled()
		return 
