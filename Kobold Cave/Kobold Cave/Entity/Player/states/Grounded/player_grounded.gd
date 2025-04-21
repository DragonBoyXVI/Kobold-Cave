@tool
extends PlayerState
class_name PlayerGrounded
## Players ground state
##
## ditto

const STATE_NAME := &"PlayerGrounded"


@export var cyote_timer: Timer
@export var crouch_timer: Timer


enum CAM_STATE {
	BE_STILL,
	FOLLOW,
}
var cam_state: CAM_STATE = CAM_STATE.BE_STILL


var _toggle_crouch := true


func _enter( _args: Dictionary ) -> void:
	
	player.velocity.y = 1.0
	update_model_direction()

func _leave() -> void:
	
	cyote_timer.stop()
	crouch_timer.stop()

func _physics_process( delta: float ) -> void:
	
	var direction := Input.get_axis( &"Move Left", &"Move Right" )
	direction *= slow
	movement.logic_walk( player, delta, direction )
	player.move_and_slide()
	
	if ( not player.is_on_floor() ):
		
		if ( player.velocity.y < 0.0 ):
			
			request_state( PlayerAir.STATE_NAME )
		elif( cyote_timer.is_stopped() ):
			
			cyote_timer.start()
			PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
	elif ( not cyote_timer.is_stopped() ):
		
		cyote_timer.stop()

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		update_model_direction()
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		movement.logic_apply_jump( player )
		request_state( PlayerAir.STATE_NAME )
		
		PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_pressed( &"Throw" ) ):
		
		var dir := Vector2.ZERO
		dir.x = model.scale.x
		dir.y -= 0.2
		
		player.bomb_thrower.throw_bomb( dir.normalized(), player.get_real_velocity() )
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Crouch" ) ):
		
		if ( event.is_pressed() ):
			
			crouch_timer.start()
		elif ( not _toggle_crouch ):
			
			crouch_timer.stop()
		
		get_window().set_input_as_handled()
		return


## used to make the model face the right way
func update_model_direction() -> void:
	
	var dir: float = signf( Input.get_axis( &"Move Left", &"Move Right" ) )
	if ( dir != 0.0 ):
		
		model.scale.x = dir
		model.animation_player.play( Player.ANIM_RUN )
	else:
		
		model.animation_player.play( Player.ANIM_IDLE )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	super( recived_data )
	
	_toggle_crouch = recived_data.toggle_crouch


func _on_cyote_timer_timeout() -> void:
	
	request_state( PlayerAir.STATE_NAME )

func _on_crouch_timer_timeout() -> void:
	
	request_state( PlayerCrouched.STATE_NAME )
