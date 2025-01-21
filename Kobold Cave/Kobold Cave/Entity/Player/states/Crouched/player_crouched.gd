@tool
extends PlayerState
class_name PlayerCrouched
## state for the player being crouched on the floor
## 
## ditto

const STATE_NAME := &"PlayerCrouched"


@onready var uncrouch_timer := %UncrouchTimer as Timer

var _toggle_crouch := true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	
	
	return warnings


func _enter() -> void:
	
	model.scale.y = 0.5

func _leave() -> void:
	
	model.scale.y = 1.0
	
	uncrouch_timer.stop()

func _physics_process( delta: float ) -> void:
	
	var direction := Input.get_axis( &"Move Left", &"Move Right" )
	direction *= 0.25 * slow
	
	player.logic_walk( delta, direction )
	player.move_and_slide()
	
	if ( not player.is_on_floor() ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action( &"Move Down" ) ):
		
		if ( event.is_pressed() ):
			
			if ( _toggle_crouch ):
				
				uncrouch_timer.start()
			else:
				
				uncrouch_timer.stop()
		else:
			
			uncrouch_timer.start()
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_pressed( &"Enter" ) or ( _press_up_to_jump and event.is_action_pressed( &"Move Up" ) ) ):
		
		player.logic_apply_jump( 1.5 )
		player.velocity.x -= ( 100.0 * model.scale.x )
		
		request_state( PlayerAir.STATE_NAME )
		
		get_window().set_input_as_handled()
		return


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	super( recived_data )
	
	_toggle_crouch = recived_data.toggle_crouch


func _on_uncrouch_timer_timeout() -> void:
	
	request_state( PlayerGrounded.STATE_NAME )
