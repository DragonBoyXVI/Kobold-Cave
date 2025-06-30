extends CanvasLayer
## manages gui related elements


## the gui root
@onready var gui_root := $GUIRoot as Control

@export var fade_rect: ColorRect


func _ready() -> void:
	
	fade_rect.color.a = 0.0
	fade_rect.hide()
	Settings.connect_changed_callback( _on_settings_updated )

func _input( event: InputEvent ) -> void:
	
	if ( event.is_action( &"Hide GUI" ) ):
		
		if ( event.is_pressed() ):
			
			hide()
		else:
			
			show()
		
		get_window().set_input_as_handled()
		return


func fade_out( time: float = 0.25 ) -> void:
	
	fade_rect.show()
	var tween := create_tween()
	tween.set_ignore_time_scale( true )
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	tween.tween_property( fade_rect, ^"color:a", 1.0, time )
	await tween.finished
	return

func fade_in( time: float = 0.25 ) -> void:
	
	var tween := create_tween()
	tween.set_ignore_time_scale( true )
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	tween.tween_property( fade_rect, ^"color:a", 0.0, time )
	await tween.finished
	fade_rect.hide()
	return


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	%ColorBlindRect.visible = recived_data.color_blind_enabled
