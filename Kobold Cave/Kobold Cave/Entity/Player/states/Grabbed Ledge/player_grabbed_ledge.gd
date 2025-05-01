@tool
extends PlayerState
class_name PlayerGrabbedLedge
##
##
##

const STATE_NAME := &"PlayerGrabbedLedge"

const TILE_SIZE := Vector2( 128.0, 128.0 )
const PLAYER_OFFSET := Vector2( 100.0, 105.0 )
const ARG_GRAB_INFO := &"Grab Info"

var current_grab: LedgeGrabInfo

var input_faces_away: bool = false


func _enter( args: Dictionary ) -> void:
	
	current_grab = args[ ARG_GRAB_INFO ]
	
	#camera_focal.global_position = current_grab.grab_position
	
	if ( current_grab.grab_to_the_right ):
		
		input_faces_away = Input.is_action_pressed( &"Move Left" )
	else:
		
		input_faces_away = Input.is_action_pressed( &"Move Right" )

func _physics_process( _delta: float ) -> void:
	
	if ( player.velocity.length_squared() > 0.0 ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( event.is_echo() ): return
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		if ( input_faces_away ):
			
			var dir: float
			if ( current_grab.grab_to_the_right ):
				
				dir = -1.0
			else:
				
				dir = 1.0
			movement.logic_apply_longjump( player, dir )
		else:
			
			movement.logic_apply_jump( player )
		
		request_state( PlayerAir.STATE_NAME )
		
		get_window().set_input_as_handled()
		return 
	
	if ( event.is_action_pressed( &"Move Down" ) ):
		
		request_state( PlayerAir.STATE_NAME, {
			PlayerAir.ARG_GRAB_TIME: 0.5
		} )
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		if ( current_grab.grab_to_the_right ):
			
			input_faces_away = Input.is_action_pressed( &"Move Left" )
		else:
			
			input_faces_away = Input.is_action_pressed( &"Move Right" )
		
		get_window().set_input_as_handled()
		return
