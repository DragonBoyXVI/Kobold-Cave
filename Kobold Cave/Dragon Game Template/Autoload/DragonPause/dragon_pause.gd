extends Node
## Manages pausing the game


## emitted when this changes the scene trees pause state
signal tree_paused( is_paused: bool )


## if true, pressing pause toggles the pause state
var is_togglable := true

## setting for if to pause when losing focus
var _pause_on_lost_focus: bool


func _init() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS

func _ready() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )


func toggle_pause(  ) -> void:
	
	if ( not is_togglable ): return
	
	var tree := get_tree()
	
	tree.paused = !tree.paused
	tree_paused.emit( tree.paused )


func _input( event: InputEvent ) -> void:
	
	if ( event.is_action_pressed( &"Pause" ) ):
		
		toggle_pause()
		
		get_viewport().set_input_as_handled()
		return

func _notification( what: int ) -> void:
	
	if ( what == NOTIFICATION_APPLICATION_FOCUS_OUT ):
		
		if ( _pause_on_lost_focus and not get_tree().paused ):
			
			toggle_pause()


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_pause_on_lost_focus = recived_data.pause_on_lost_focus
