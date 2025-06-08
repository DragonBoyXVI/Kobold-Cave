@tool
extends ObjSettingHSlider
class_name ObjHSliderFPS
## The setting slider for fps control
##
## ditto

@export var unlimited_setting_changer: SettingChanger = preload( "uid://dwgs2bk688404" )
@export_group( "Innards" )
@export var unlimited_button: Button


func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	unlimited_button.toggled.connect( _on_unlimited_button_toggled, CONNECT_DEFERRED )


func _on_default_button_pressed() -> void:
	
	if ( slider.editable ):
		
		super()

func _on_unlimited_button_toggled( toggled_on: bool ) -> void:
	
	unlimited_setting_changer.change_setting( toggled_on )

func _on_settings_updated( new_file: SettingsFile ) -> void:
	super( new_file )
	
	unlimited_button.set_pressed_no_signal( new_file.frame_rate_unlimited )
	slider.editable = not new_file.frame_rate_unlimited
	spin_box.editable = not new_file.frame_rate_unlimited
