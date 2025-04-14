@tool
extends PlayerState
class_name PlayerCrouched
## state for the player being crouched on the floor
## 
## ditto

const STATE_NAME := &"PlayerCrouched"


@export var standing_shape: CollisionShape2D
@export var crouched_shape: CollisionShape2D


@onready var uncrouch_timer := %UncrouchTimer as Timer


var _toggle_crouch := true


func _enter( _args: Dictionary ) -> void:
	
	model.scale.y = 0.5
	update_animation()
	
	if ( standing_shape and crouched_shape ):
		
		crouched_shape.set_deferred( &"disabled", false )
		standing_shape.set_deferred( &"disabled", true )

func _leave() -> void:
	
	model.scale.y = 1.0
	
	uncrouch_timer.stop()
	
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
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		update_animation()
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Crouch" ) ):
		
		if ( event.is_pressed() ):
			
			if ( _toggle_crouch ):
				
				uncrouch_timer.start()
			else:
				
				uncrouch_timer.stop()
		else:
			
			uncrouch_timer.start()
		
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
	
	if ( event.is_action_pressed( &"Throw" ) ):
		
		player.bomb_thrower.throw_bomb( Vector2.DOWN, player.get_real_velocity() )
		
		get_window().set_input_as_handled()
		return


func update_animation() -> void:
	
	var dir: float = Input.get_axis( &"Move Left", &"Move Right" )
	if ( is_zero_approx( dir ) ):
		
		model.animation_player.play( ANIM_IDLE )
	else:
		
		model.animation_player.play( ANIM_RUN )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	super( recived_data )
	
	_toggle_crouch = recived_data.toggle_crouch


func _on_uncrouch_timer_timeout() -> void:
	
	request_state( PlayerGrounded.STATE_NAME )
