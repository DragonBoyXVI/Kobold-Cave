@tool
extends PlayerState
class_name PlayerStateAir
## player air state
##
## ditto


@export var ground_state: StringName = &"" : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		ground_state = value


@onready var jump_timer := %jumpTimer as Timer


var jump_with_up := true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( ground_state.is_empty() ):
		
		const text := "Please provide the name of the ground state!"
		warnings.append( text )
	
	return warnings


func _leave() -> void:
	
	jump_timer.stop()
	model.root.scale = Vector2.ONE
	model.rotation = 0.0

func _process( _delta: float ) -> void:
	
	# stretch
	const stretch_max := 0.15
	
	var fall_amount: float = absf( player.velocity.y ) / movement_stats.air_terminal_velocity
	
	var stretch_y: float = 1.0 + ( stretch_max * fall_amount )
	var stretch_x: float = 2.0 - stretch_y
	
	model.root.scale = Vector2( stretch_x, stretch_y )
	
	# rotation
	const rotate_max := deg_to_rad( 25.0 )
	
	var rotate_amount: float = player.velocity.x / movement_stats.air_terminal_velocity
	model.rotation = rotate_max * rotate_amount

func _physics_process( delta: float ) -> void:
	
	var direction := Vector2.ZERO
	direction.x = Input.get_axis( &"Move Left", &"Move Right" )
	if ( Input.is_action_pressed( &"Enter" ) ):
		
		direction.y = -1.0
	else:
		
		direction.y = Input.get_axis( &"Move Up", &"Move Down" )
	
	player.logic_air_strafe( delta, direction.x )
	player.logic_gravity( delta, direction.y )
	player.logic_terminal_velocity( delta )
	
	player.move_and_slide()
	
	if ( player.is_on_floor() ):
		
		if ( not jump_timer.is_stopped() ):
			
			player.logic_apply_jump()
			return
		
		request_state( ground_state )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Enter" ) or ( jump_with_up and event.is_action_pressed( &"Move Up" ) ) ):
		
		jump_timer.start()
		
		get_window().set_input_as_handled()
		return
