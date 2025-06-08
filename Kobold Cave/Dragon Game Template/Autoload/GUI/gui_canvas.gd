extends CanvasLayer
## manages gui related elements


## the gui root
@onready var gui_root := $GUIRoot as Control


func _ready() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )

func _input( event: InputEvent ) -> void:
	
	if ( event.is_action( &"Hide GUI" ) ):
		
		if ( event.is_pressed() ):
			
			hide()
		else:
			
			show()
		
		get_window().set_input_as_handled()
		return


## Start gui process
func enable() -> void:
	
	process_mode = PROCESS_MODE_ALWAYS

## stop gui process
func disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED


## adds a gui element to GUI. add an index to set the child order
func add_gui_element( new_gui: Control, index: int = 0 ) -> void:
	
	gui_root.add_child( new_gui )
	
	if ( index ):
		
		gui_root.move_child( new_gui, index )

## removed a gui element, set free it to true to also queue_free the node
func remove_gui_element( removed_gui: Control, free_it: bool = false ) -> void:
	
	gui_root.remove_child( removed_gui )
	
	if ( free_it ):
		
		removed_gui.queue_free()



func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	%ColorBlindRect.visible = recived_data.color_blind_enabled
