@tool
extends PlayerState
class_name PlayerAir
## player air state
##
## ditto


const STATE_NAME := &"PlayerAir"


@export var ledge_grabber: LedgeGrabDetector
@export var bomb_thrower: BombThrower

@onready var jump_timer := %jumpTimer as Timer
@onready var stuck_timer := %StuckTimer as Timer
@onready var grab_timer: Timer = %GrabTimer


const ARG_GRAB_TIME := &"Grab Time"


func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	model.animation_player.play( Player.ANIM_JUMP if player.velocity.y < 0 else Player.ANIM_FALL )
	
	grab_timer.start( args[ ARG_GRAB_TIME ] )
	stuck_timer.start()

func _leave() -> void:
	
	ledge_grabber.disable.call_deferred()
	jump_timer.stop()
	stuck_timer.stop()
	grab_timer.stop()
	
	model.root.scale = Vector2.ONE
	model.rotation = 0.0
	model.animation_player.speed_scale = 1.0

func _process( _delta: float ) -> void:
	
	# stretch
	const stretch_max := 0.15
	
	var fall_amount: float = absf( player.velocity.y ) / movement.air_terminal_velocity
	
	var stretch_y: float = 1.0 + ( stretch_max * fall_amount )
	var stretch_x: float = 2.0 - stretch_y
	
	model.root.scale = Vector2( stretch_x, stretch_y )
	
	# rotation
	const rotate_max := deg_to_rad( 25.0 )
	
	var rotate_amount: float = player.velocity.x / movement.air_terminal_velocity
	model.rotation = rotate_max * rotate_amount
	
	# anim
	if ( model.animation_player.current_animation == Player.ANIM_FALL ):
		if ( player.velocity.y < 0 ):
			
			model.animation_player.play( Player.ANIM_JUMP )
			model.animation_player.speed_scale = 1.0
		else:
			
			var fall_speed: float = player.velocity.length_squared() / movement.air_terminal_squared
			model.animation_player.speed_scale = fall_speed * 5.0
	elif( model.animation_player.current_animation == Player.ANIM_JUMP ):
		if ( player.velocity.y > 0 ):
			
			model.animation_player.play( Player.ANIM_FALL )

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
	
	movement.routine_airborne( player, delta, direction )
	player.move_and_slide()
	
	if ( player.is_on_floor() ):
		
		PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
		
		if ( not jump_timer.is_stopped() ):
			
			movement.logic_apply_jump( player )
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
	
	if ( event.is_action_pressed( &"Throw" ) ):
		
		var dir := Vector2.ZERO
		dir.x = model.scale.x
		dir.y -= 0.8
		
		bomb_thrower.throw_bomb( dir.normalized(), player.get_real_velocity() )
		
		get_window().set_input_as_handled()
		return


func _on_stuck_timer_timeout() -> void:
	
	push_warning( "Falling forever are we?" )
	KoboldRadio.player_reset_needed.emit( player )

func _on_grab_timer_timeout() -> void:
	
	ledge_grabber.enable.call_deferred()
