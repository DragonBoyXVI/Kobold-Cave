
extends Object
class_name DragonUIAnimations
## Utility script for some ui animations
##
## ditto


static var _speed_scale: float = 1.0


static func _static_init() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )


## fades a control to be semi transparent, or fully opaque if fade in is true
static func fade_control( control: Control, fade_in: bool, time: float = 0.1 ) -> void:
	
	var tween := control.create_tween()
	tween.set_ignore_time_scale( true )
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	var fade_alpha: float = 1.0 if fade_in else 0.05
	fade_alpha *= _speed_scale
	
	tween.tween_property( control, ^"modulate:a", fade_alpha, time )


static func _on_settings_updated( new_file: SettingsFile ) -> void:
	
	_speed_scale = new_file.ui_animation_speed
