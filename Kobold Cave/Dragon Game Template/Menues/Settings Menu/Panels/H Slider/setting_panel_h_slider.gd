@tool
extends SettingPanel
class_name ObjSettingHSlider
## A slider that changes a setting
##
## ditto

@export_group( "Internals" )
@export var slider: Slider
@export var spin_box: SpinBox
@export var default_button: Button


func _ready() -> void:
	super()
	
	if ( slider and spin_box ):
		
		slider.share( spin_box )
	
	if ( Engine.is_editor_hint() ): 
		return
	
	Settings.connect_changed_callback( _on_settings_updated, 0, setting_changer.setting_flags )
	
	slider.set_value_no_signal( Settings.current_file.get( setting_changer.setting_name ) )
	
	slider.value_changed.connect( _on_value_changed )
	default_button.pressed.connect( _on_default_button_pressed, CONNECT_DEFERRED )


func _on_value_changed( value: float ) -> void:
	
	setting_changer.change_setting( value )

func _on_default_button_pressed() -> void:
	
	if ( setting_changer ):
		setting_changer.reset_setting()

func _on_settings_updated( new_file: SettingsFile ) -> void:
	
	if ( slider.has_focus() ): return
	if ( spin_box.has_focus() ): return
	
	if ( setting_changer ):
		slider.set_value_no_signal( new_file.get( setting_changer.setting_name ) )
