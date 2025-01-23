@tool
extends PlayerState
class_name PlayerAir
## player air state
##
## ditto

const STATE_NAME := &"PlayerAir"


const AREA_PROP := &"monitoring"

@export var ledge_grabber: LedgeGrabDetector

@onready var jump_timer := %jumpTimer as Timer


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	if ( ledge_grabber ):
		
		ledge_grabber.found_grab_ledge.connect( _on_ledge_found )
		ledge_grabber.set_deferred( AREA_PROP, false )


func _enter() -> void:
	
	ledge_grabber.set_deferred( AREA_PROP, true )

func _leave() -> void:
	
	ledge_grabber.set_deferred( AREA_PROP, false )
	
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
	if ( Input.is_action_pressed( &"Enter" ) ):
		
		direction.y = -1.0
	else:
		
		direction.y = Input.get_axis( &"Move Up", &"Move Down" )
	
	player.routine_airborne( delta, direction )
	
	player.move_and_slide()
	
	if ( player.is_on_floor() ):
		
		if ( not jump_timer.is_stopped() ):
			
			player.logic_apply_jump()
			return
		
		request_state( PlayerGrounded.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	if ( get_window().is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Enter" ) or ( _press_up_to_jump and event.is_action_pressed( &"Move Up" ) ) ):
		
		jump_timer.start()
		
		get_window().set_input_as_handled()
		return


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	super( recived_data )


func _on_ledge_found( info: LedgeGrabInfo ) -> void:
	if ( not can_process() ): return
	if ( player.is_on_floor() ): return
	
	player.disable.call_deferred()
	player.set_deferred( &"global_position", info.grab_position )
	
	await get_tree().create_timer( 5.0 ).timeout
	
	player.enable.call_deferred()
