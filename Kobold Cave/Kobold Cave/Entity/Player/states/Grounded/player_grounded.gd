@tool
extends PlayerState
class_name PlayerStateGrounded
## Players ground state
##
## ditto


## the state name to call when we go airborne
@export var air_state: StringName = &"" : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		air_state = value


@onready var cyote_timer := %CyoteTimer as Timer


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( air_state.is_empty() ):
		
		const text := "Please provide the name of the air state!"
		warnings.append( text )
	
	return warnings


func _enter() -> void:
	
	player.velocity.y = 1.0

func _leave() -> void:
	
	cyote_timer.stop()

func _physics_process( delta: float ) -> void:
	
	var direction := Input.get_axis( &"Move Left", &"Move Right" )
	direction *= slow
	player.logic_walk( delta, direction )
	
	player.move_and_slide()
	
	if ( not player.is_on_floor() ):
		
		if ( player.velocity.y < 0.0 ):
			
			request_state( air_state )
		elif( cyote_timer.is_stopped() ):
			
			cyote_timer.start()

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Move Up" ) ):
		
		player.logic_apply_jump()
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		var dir: float = signf( Input.get_axis( &"Move Left", &"Move Right" ) )
		if ( dir != 0.0 ):
			
			model.scale.x = dir


func _on_cyote_timer_timeout() -> void:
	
	request_state( air_state )
