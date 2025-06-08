extends Object
class_name DragonPauser
## Manages pausing the game
##
## ditto


## if true, pressing pause toggles the pause state
static var is_togglable := true

## setting for if to pause when losing focus
static var _pause_on_lost_focus: bool


static func _static_init() -> void:
	
	var window: Window = Engine.get_main_loop().root
	
	window.window_input.connect( _on_window_input )
	window.focus_exited.connect( _on_window_lost_focus )


## used by settings to load this class, not meant to
## be used elsewhere
static func hookup_to_settings() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )

## used to toggle the pause state
static func toggle_pause(  ) -> void:
	
	if ( not is_togglable ): return
	
	var tree: SceneTree = Engine.get_main_loop()
	
	# deferring here gives a more consistent result
	tree.set_deferred( &"paused", !tree.paused )
	# dont think it matters if this signal is deferred
	DragonRadio.pause_toggled.emit( !tree.paused )

## set the pause state specifically~
static func set_pause( paused: bool ) -> void:
	
	if ( not is_togglable ): return
	
	var tree: SceneTree = Engine.get_main_loop()
	
	if ( tree.paused == paused ): return
	
	tree.set_deferred( &"paused", paused )
	DragonRadio.pause_toggled.emit( paused )

## connect the func to the pause signal
static func connect_to_pause( callback: Callable, flags: int = 0 ) -> void:
	
	DragonRadio.pause_toggled.connect( callback, flags )


static func _on_window_input( event: InputEvent ) -> void:
	if ( event.is_echo() ): return
	
	if ( event.is_action_pressed( &"Pause" ) ):
		
		toggle_pause()
		
		Engine.get_main_loop().root.set_input_as_handled()
		return

static func _on_window_lost_focus(  ) -> void:
	
	if ( _pause_on_lost_focus and not Engine.get_main_loop().paused ):
		
		toggle_pause()


static func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_pause_on_lost_focus = recived_data.pause_on_lost_focus
