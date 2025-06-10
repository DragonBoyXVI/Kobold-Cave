@tool
extends PlayerState
class_name PlayerAir
## player air state
##
## ditto


const STATE_NAME := &"PlayerAir"


@export var ledge_grabber: LedgeGrabDetector
@export var bomb_thrower: BombThrower

## how long the jump input is saved for when you press jump
@export var jump_time: float = 0.25
## if you fall for too long, you'll automatically be reset
@export var stuck_time: float = 30.0


const ARG_GRAB_TIME := &"Grab Time"


var _jump_timer: SceneTreeTimer
var _stuck_timer: SceneTreeTimer
var _grab_timer: SceneTreeTimer

var is_jump_stored: bool = false
var is_grab_ready: bool = false


func _init() -> void:
	
	use_slow = true
	_internal_default_args[ ARG_GRAB_TIME ] = 0.5
	super()

func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	model.animation_player.play( Player.ANIM_JUMP if player.velocity.y < 0 else Player.ANIM_FALL )
	
	is_jump_stored = false
	is_grab_ready = false
	
	_grab_timer = create_physics_tree_timer( args[ ARG_GRAB_TIME ], _on_grab_timer_timeout )
	_stuck_timer = create_physics_tree_timer( stuck_time, _on_stuck_timer_timeout )

func _leave() -> void:
	
	ledge_grabber.disable.call_deferred()
	
	_jump_timer = stop_timer( _jump_timer )
	_stuck_timer = stop_timer( _stuck_timer )
	_grab_timer = stop_timer( _grab_timer )
	
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
	var fall_speed: float = player.velocity.length_squared() / movement.air_terminal_squared
	model.animation_player.speed_scale = fall_speed * 5.0
	if ( model.animation_player.current_animation == Player.ANIM_FALL ):
		if ( player.velocity.y < 0 ):
			
			model.animation_player.play( Player.ANIM_JUMP )
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
		
		if ( is_jump_stored ):
			
			movement.logic_apply_jump( player )
			return
		
		const snd: AudioStream = preload( "uid://b6bja1q8f8v6v" )
		DragonSound.in_world.play_sound_2d( snd, player.global_position )
		
		if ( Input.is_action_pressed( &"Crouch" ) ):
			
			request_state( PlayerCrouched.STATE_NAME )
		else:
			
			request_state( PlayerGrounded.STATE_NAME )
	else:
		
		if ( is_grab_ready ):
			if ( ledge_grabber.can_process() ):
				if ( player.velocity.y < 0.0 ):
					
					ledge_grabber.disable.call_deferred()
			else:
				if ( player.velocity.y > 0.0 ):
					
					ledge_grabber.enable.call_deferred()

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	
	if ( event.is_action( &"Throw" ) ):
		
		var dir := Vector2.ZERO
		dir.x = model.scale.x
		dir.y -= 0.8
		
		bomb_thrower.throw_bomb( dir.normalized(), player.velocity )
		
		get_window().set_input_as_handled()
		return
	
	
	if ( event.is_echo() ): return
	
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		_jump_timer = create_physics_tree_timer( jump_time, _on_jump_timer_timeout )
		is_jump_stored = true
		
		get_window().set_input_as_handled()
		return


func _on_jump_timer_timeout() -> void:
	
	is_jump_stored = false

func _on_stuck_timer_timeout() -> void:
	
	push_warning( "Falling forever are we?" )
	KoboldRadio.player_reset_needed.emit( player )
	
	_stuck_timer = create_physics_tree_timer( stuck_time, _on_stuck_timer_timeout )

func _on_grab_timer_timeout() -> void:
	
	is_grab_ready = true
