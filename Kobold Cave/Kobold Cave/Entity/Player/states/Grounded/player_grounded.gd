@tool
extends PlayerState
class_name PlayerGrounded
## Players ground state
##
## ditto

const STATE_NAME := &"PlayerGrounded"

@export var focal_curve: Curve
const FOCAL_DISPLACEMENT := 128.0

@onready var cyote_timer := %CyoteTimer as Timer
@onready var crouch_timer := %CrouchTimer as Timer


var _toggle_crouch := true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not focal_curve ):
		
		const text := "Camera focal curve is empty!"
		warnings.append( text )
	
	return warnings


func _enter( _args: Dictionary ) -> void:
	
	camera_focal.position = CAMERA_FOCAL_OFFSET
	player.velocity.y = 1.0
	update_model_direction()

func _leave() -> void:
	
	cyote_timer.stop()
	crouch_timer.stop()

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
			
			request_state( PlayerAir.STATE_NAME )
		elif( cyote_timer.is_stopped() ):
			
			cyote_timer.start()
			PartManager.spawn_dust( player.position )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action( &"Move Left" ) or event.is_action( &"Move Right" ) ):
		
		update_model_direction()
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		player.logic_apply_jump()
		request_state( PlayerAir.STATE_NAME )
		
		PartManager.spawn_dust( player.position )
		
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


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	super( recived_data )
	
	_toggle_crouch = recived_data.toggle_crouch


func _on_cyote_timer_timeout() -> void:
	
	request_state( PlayerAir.STATE_NAME )

func _on_crouch_timer_timeout() -> void:
	
	request_state( PlayerCrouched.STATE_NAME )
