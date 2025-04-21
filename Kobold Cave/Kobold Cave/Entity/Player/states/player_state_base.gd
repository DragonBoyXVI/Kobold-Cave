@tool
extends StateBehaviour
class_name PlayerState
## base for player states
##
## ditto


const movement: MovementGround = preload( "uid://c08ur33jqim3p" )

## if true, the slow value is updated when needed.[br]
## (you still need to use the slow value in code)
@export var use_slow: bool = false

@export var player: Player :
	set( new_player ):
		update_configuration_warnings.call_deferred()
		
		player = new_player
@export var model: DragonModel2D :
	set( new_model ):
		update_configuration_warnings.call_deferred()
		
		model = new_model


const SLOW_NORMAL := 1.0
const SLOW_SLOW := 0.05

var slow: float = SLOW_NORMAL


func enter( args: Dictionary[ StringName, Variant ] = {} ) -> void:
	super( args )
	
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
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
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


func _on_settings_updated( _recived_data: SettingsFile ) -> void:
	pass
