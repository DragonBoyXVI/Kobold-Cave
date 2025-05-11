extends Node
## Manages controler related data, such as if you're using
## kb and mouse/gamepad, and pasuing the game


## emitted when this changes the scene trees pause state
signal tree_paused( is_paused: bool )

var _pause_on_lost_focus: bool

var can_toggle_pause: bool = true

func _input( event: InputEvent ) -> void:
	
	if ( event.is_echo() ): return
	
	#region pause the game
	
	if ( event.is_action_pressed( &"Pause" ) ):
		
		toggle_pause_state.call_deferred()
		
		get_viewport().set_input_as_handled()
		return
	
	#endregion

func _notification( what: int ) -> void:
	
	if ( what == NOTIFICATION_APPLICATION_FOCUS_OUT ):
		
		if ( _pause_on_lost_focus and not get_tree().paused ):
			
			toggle_pause_state.call_deferred()

func _ready() -> void:
	
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )


func toggle_pause_state() -> void:
	
	if ( not can_toggle_pause ): return
	
	var tree := get_tree()
	
	tree.paused = !tree.paused
	tree_paused.emit( tree.paused )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_pause_on_lost_focus = recived_data.pause_on_lost_focus
