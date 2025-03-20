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


var input_faces_away: bool = false


func _enter( args: Dictionary ) -> void:
	
	grab_position = args[ ARG_GRAB_POSITION ]
	grab_right_side = args[ ARG_GRAB_RIGHT ]
	
	camera_focal.global_position = grab_position
	
	if ( grab_right_side ):
		
		input_faces_away = Input.is_action_pressed( &"Move Left" )
	else:
		
		input_faces_away = Input.is_action_pressed( &"Move Right" )

func _physics_process( _delta: float ) -> void:
	
	if ( player.velocity.length_squared() > 0.0 ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		if ( input_faces_away ):
			
			var dir: float
			if ( grab_right_side ):
				
				dir = -1.0
			else:
				
				dir = 1.0
			player.logic_apply_longjump( dir )
		else:
			
			player.logic_apply_jump()
		
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
		
		if ( grab_right_side ):
			
			input_faces_away = Input.is_action_pressed( &"Move Left" )
		else:
			
			input_faces_away = Input.is_action_pressed( &"Move Right" )
		
		if ( input_faces_away ):
			
			var offset: float = TILE_SIZE.x * 2.0
			if ( grab_right_side ):
				
				offset *= -1.0
			camera_focal.global_position.x = grab_position.x + offset
		else:
			
			camera_focal.global_position = grab_position
		
		get_window().set_input_as_handled()
		return
