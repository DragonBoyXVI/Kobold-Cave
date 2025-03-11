extends Node
## Manages controler related data, such as if you're using
## kb and mouse/gamepad, and pasuing the game


## emitted when this changes the scene trees pause state
signal tree_paused( is_paused: bool )

var _pause_on_lost_focus: bool

func _input( event: InputEvent ) -> void:
	
	#region pause the game
	
	if ( event.is_action_pressed( &"Pause" ) ):
		
		var tree := get_tree()
		
		tree.paused = !tree.paused
		tree_paused.emit( tree.paused )
		
		get_viewport().set_input_as_handled()
		return
	
	#endregion

func _notification( what: int ) -> void:
	
	if ( what == NOTIFICATION_APPLICATION_FOCUS_OUT ):
		
		if ( _pause_on_lost_focus and not get_tree().paused ):
			
			var input := InputEventAction.new()
			input.action = &"Pause"
			input.pressed = true
			
			Input.parse_input_event( input )

func _ready() -> void:
	
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_pause_on_lost_focus = recived_data.pause_on_lost_focus
