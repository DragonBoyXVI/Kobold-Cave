@tool
extends StateBehaviour
class_name PlayerState
## base for player states
##
## ditto


## if true, the slow value is updated when needed.[br]
## (you still need to use the slow value in code)
@export var use_slow: bool = false

@export var player: Player :
	set( new_player ):
		update_configuration_warnings.call_deferred()
		
		player = new_player
		if ( player and player.movement_stats ):
			
			movement_stats = player.movement_stats
@export var movement_stats: MovementData : 
	set( new_stats ):
		update_configuration_warnings.call_deferred()
		
		movement_stats = new_stats
@export var model: DragonModel2D :
	set( new_model ):
		update_configuration_warnings.call_deferred()
		
		model = new_model
@export var camera_focal: CameraFocal2D :
	set( new_focal ):
		update_configuration_warnings.call_deferred()
		
		camera_focal = new_focal


const SLOW_NORMAL := 1.0
const SLOW_SLOW := 0.05

var slow: float = SLOW_NORMAL


const CAMERA_FOCAL_OFFSET := Vector2( 0.0, -48.0 )


var _press_up_to_jump := true


func enter() -> void:
	super()
	
	if ( use_slow ):
		
		slow = SLOW_NORMAL
		if ( Input.is_action_pressed( &"Slow" ) ):
			
			slow = SLOW_SLOW


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not player ):
		
		const text := "A player is needed for this state!"
		warnings.append( text )
	
	if ( not model ):
		
		const text := "A model is needed for this state!"
		warnings.append( text )
	
	if ( not camera_focal ):
		
		const text := "Please provide a camera focal point!"
		warnings.append( text )
	
	if ( not movement_stats ):
		
		const text := "We want the players movement stats! Either resupply the player node or place the resource here."
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		set_process( false )
		set_physics_process( false )
		set_process_input( false )
		set_process_unhandled_input( false )
		return
	
	Settings.loaded.connect( _on_settings_updated )
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )

func _unhandled_input( event: InputEvent ) -> void:
	
	if ( event.is_action( &"Slow" ) ):
		
		slow = SLOW_NORMAL
		if ( event.is_pressed() ):
			
			slow = SLOW_SLOW
		
		get_window().set_input_as_handled()
		return


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_press_up_to_jump = recived_data.press_up_to_jump
