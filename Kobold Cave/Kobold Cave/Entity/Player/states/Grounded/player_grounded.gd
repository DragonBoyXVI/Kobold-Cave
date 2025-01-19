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

@export var focal_curve: Curve
const FOCAL_DISPLACEMENT := 128.0 * 1.5

@onready var cyote_timer := %CyoteTimer as Timer


var jump_with_up := true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( air_state.is_empty() ):
		
		const text := "Please provide the name of the air state!"
		warnings.append( text )
	
	if ( not focal_curve ):
		
		const text := "Camera focal curve is empty!"
		warnings.append( text )
	
	return warnings


func _enter() -> void:
	
	player.velocity.y = 1.0
	update_model_direction()

func _leave() -> void:
	
	cyote_timer.stop()

func _process( _delta: float ) -> void:
	
	var direction:= Input.get_axis( &"Move Left", &"Move Right" )
	direction = ( direction / 2.0 ) + 0.5 #faster? #remap( direction, -1.0, 1.0, 0.0, 1.0 )
	
	var sample := focal_curve.sample_baked( direction )
	camera_focal.position.x = CAMERA_FOCAL_OFFSET.x + ( FOCAL_DISPLACEMENT * sample )

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
	
	if ( event.is_action_pressed( &"Enter" ) or ( jump_with_up and event.is_action_pressed( &"Move Up" ) ) ):
		
		player.logic_apply_jump()
		request_state( air_state )
		
		get_window().set_input_as_handled()
		return
	
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		update_model_direction()


## used to make the model face the right way
func update_model_direction() -> void:
	
		var dir: float = signf( Input.get_axis( &"Move Left", &"Move Right" ) )
		if ( dir != 0.0 ):
			
			model.scale.x = dir


func _on_cyote_timer_timeout() -> void:
	
	request_state( air_state )
