@tool
extends PlayerState
class_name PlayerAir
## player air state
##
## ditto

const STATE_NAME := &"PlayerAir"


@export var ledge_grabber: LedgeGrabDetector

@onready var jump_timer := %jumpTimer as Timer


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	return warnings


func _enter() -> void:
	
	ledge_grabber.enable.call_deferred()

func _leave() -> void:
	
	ledge_grabber.disable.call_deferred()
	
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
	
	# movement feels nicer if the direction isnt normalized
	# setting?
	var direction := Vector2.ZERO
	direction.x = Input.get_axis( &"Move Left", &"Move Right" )
	if ( Input.is_action_pressed( &"Jump" ) ):
		
		direction.y = -1.0
	else:
		
		direction.y = Input.get_axis( &"Move Up", &"Move Down" )
	direction.x *= slow
	
	player.routine_airborne( delta, direction )
	
	player.move_and_slide()
	
	if ( player.is_on_floor() ):
		
		if ( not jump_timer.is_stopped() ):
			
			player.logic_apply_jump()
			return
		
		if ( Input.is_action_pressed( &"Crouch" ) ):
			
			request_state( PlayerCrouched.STATE_NAME )
		else:
			
			request_state( PlayerGrounded.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		jump_timer.start()
		
		get_window().set_input_as_handled()
		return
