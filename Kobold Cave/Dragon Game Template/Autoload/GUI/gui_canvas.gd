extends CanvasLayer
## manages gui related elements


## the gui root
@onready var gui_root := $GUIRoot as Control


func _ready() -> void:
	
	Settings.loaded.connect( _on_settings_updated )
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )

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


@onready var fade_rect: ColorRect = $FadeRect
func fade_out( fade_time: float = 1.25, fade_color: Color = Color.BLACK ) -> void:
	
	KoboldUtility.in_level_trans = true
	KoboldRadio.room_pause.emit()
	fade_rect.show()
	var tween := create_tween()
	
	tween.tween_property( fade_rect, ^"color", fade_color, fade_time )
	await tween.finished
	return

func fade_in( fade_time: float = 1.25 ) -> void:
	
	var tween := create_tween()
	
	tween.tween_property( fade_rect, ^"color", Color( Color.BLACK, 0.0 ), fade_time )
	await tween.finished
	fade_rect.hide()
	KoboldUtility.in_level_trans = false
	KoboldRadio.room_unpause.emit()
	return


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	%ColorBlindRect.visible = recived_data.color_blind_enabled
