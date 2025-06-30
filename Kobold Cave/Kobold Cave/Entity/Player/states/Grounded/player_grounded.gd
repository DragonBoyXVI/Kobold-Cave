@tool
extends PlayerState
class_name PlayerGrounded
## Players ground state
##
## ditto

const STATE_NAME := &"PlayerGrounded"


@export var cyote_timer: Timer
@export var crouch_timer: Timer

var is_in_cyote: bool = false
var is_crouching: bool = false


enum CAM_STATE {
	BE_STILL,
	FOLLOW,
}
var cam_state: CAM_STATE = CAM_STATE.BE_STILL


func _init() -> void:
	super()
	
	use_slow = true

func  _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	cyote_timer.timeout.connect( _on_cyote_timer_timeout )
	crouch_timer.timeout.connect( _on_crouch_timer_timeout )

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
		elif( not is_in_cyote ):
			
			cyote_timer.start()
			is_in_cyote = true
			PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
	elif ( is_in_cyote ):
		
		is_in_cyote = false
		cyote_timer.stop()

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	
	if ( event.is_action( &"Throw" ) ):
		
		var dir := Vector2.ZERO
		dir.x = 1.0 if player.is_facing_right else -1.0
		dir.y -= 0.2
		
		player.bomb_thrower.throw_bomb( dir.normalized(), player.velocity )
		
		get_window().set_input_as_handled()
		return
	
	
	if ( event.is_echo() ): return
	
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		if ( event.is_echo() ): return
		
		update_model_direction()
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		movement.logic_apply_jump( player )
		request_state( PlayerAir.STATE_NAME )
		
		PartManager.spawn_particles( player.position, PartManager.SMALL_DUST )
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action( &"Crouch" ) ):
		
		if ( event.is_pressed() ):
			
			crouch_timer.start()
			is_crouching = true
		elif ( not _toggle_crouch ):
			
			crouch_timer.stop()
			is_crouching = false
		
		get_window().set_input_as_handled()
		return


## used to make the model face the right way
func update_model_direction() -> void:
	
	var dir: float = signf( Input.get_axis( &"Move Left", &"Move Right" ) )
	
	model.animation_player.play( KoboldModel2D.ANIM_RESET )
	model.animation_player.advance( 0.0 )
	if ( dir != 0.0 ):
		
		player.is_facing_right = dir > 0.0
		model.animation_player.play( KoboldModel2D.ANIM_RUN )
	else:
		
		model.animation_player.play( KoboldModel2D.ANIM_IDLE )


func _on_cyote_timer_timeout() -> void:
	
	request_state( PlayerAir.STATE_NAME )

func _on_crouch_timer_timeout() -> void:
	
	request_state( PlayerCrouched.STATE_NAME )
