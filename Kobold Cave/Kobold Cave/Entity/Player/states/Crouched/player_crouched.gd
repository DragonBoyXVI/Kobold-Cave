@tool
extends PlayerState
class_name PlayerCrouched
## state for the player being crouched on the floor
## 
## ditto

const STATE_NAME := &"PlayerCrouched"


@export var standing_shape: CollisionShape2D
@export var crouched_shape: CollisionShape2D

@export var uncrouch_time: float = 0.1


var _uncrouch_timer: SceneTreeTimer


func _init() -> void:
	super()
	
	use_slow = true

func _enter( _args: Dictionary ) -> void:
	
	update_animation()
	
	if ( standing_shape and crouched_shape ):
		
		crouched_shape.set_deferred( &"disabled", false )
		standing_shape.set_deferred( &"disabled", true )

func _leave() -> void:
	
	_uncrouch_timer = stop_timer( _uncrouch_timer )
	
	if ( standing_shape and crouched_shape ):
		
		crouched_shape.set_deferred( &"disabled", true )
		standing_shape.set_deferred( &"disabled", false )

func _physics_process( delta: float ) -> void:
	
	var direction := Input.get_axis( &"Move Left", &"Move Right" )
	direction *= 0.25 * slow
	
	movement.logic_walk( player, delta, direction )
	player.move_and_slide()
	
	if ( not player.is_on_floor() ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	
	if ( event.is_action( &"Throw" ) ):
		
		player.bomb_thrower.throw_bomb( Vector2.DOWN, player.get_real_velocity() )
		
		get_window().set_input_as_handled()
		return
	
	
	if ( event.is_echo() ):	return
	
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		if ( event.is_echo() ): return
		
		update_animation()
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Crouch" ) ):
		
		if ( event.is_pressed() ):
			
			if ( _toggle_crouch ):
				
				_uncrouch_timer = create_physics_tree_timer( uncrouch_time, _on_uncrouch_timer_timeout )
			else:
				
				_uncrouch_timer = stop_timer( _uncrouch_timer )
		else:
			
			_uncrouch_timer = create_physics_tree_timer( uncrouch_time, _on_uncrouch_timer_timeout )
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		var direction := Input.get_axis( &"Move Left", &"Move Right" )
		direction = signf( direction )
		
		const _focal_displacement := 256.0
		
		var model_dir: float = signf( model.scale.x )
		if ( model_dir == direction ):
			
			movement.logic_apply_longjump( player, direction )
			#camera_focal.position.x = CAMERA_FOCAL_OFFSET.x + ( focal_displacement * direction )
		else:
			
			movement.logic_apply_backflip( player, direction )
		
		#camera_focal.position.x = CAMERA_FOCAL_OFFSET.x + ( focal_displacement * direction )
		
		request_state( PlayerAir.STATE_NAME )
		
		PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
		
		get_window().set_input_as_handled()
		return


func update_animation() -> void:
	
	var dir: float = Input.get_axis( &"Move Left", &"Move Right" )
	var is_dir_right: bool = dir > 0.0
	
	#model.animation_player.play( Player.ANIM_RESET )
	#model.animation_player.advance( 0.0 )
	if ( is_zero_approx( dir ) ):
		
		model.animation_player.play( Player.ANIM_IDLE_CROUCHED )
	else:
		
		if ( model.is_facing_right == is_dir_right ):
			
			model.animation_player.play( Player.ANIM_RUN_CROUCHED_FORWARD )
		else:
			
			model.animation_player.play( Player.ANIM_RUN_CROUCHED_FORWARD, -1.0, -1.0, false )
			#model.animation_player.play( Player.ANIM_RUN_CROUCHED_BACKWARD )




func _on_uncrouch_timer_timeout() -> void:
	
	request_state( PlayerGrounded.STATE_NAME )
