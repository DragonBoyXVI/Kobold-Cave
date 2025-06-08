@tool
extends SettingPanel
class_name ObjSettingCheckButton
## changes a [bool] setting
##
## ditto


@export_group( "Innards" )
@export var check_button: CheckButton


func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	Settings.connect_changed_callback( _on_settings_updated )
	
	check_button.toggled.connect( _on_check_button_toggled )


func _on_check_button_toggled( toggled_on: bool ) -> void:
	
	setting_changer.change_setting( toggled_on )

func _on_settings_updated( new_file: SettingsFile ) -> void:
	
	if ( check_button.has_focus() ): return
	
	check_button.set_pressed_no_signal( new_file.get( setting_changer.setting_name ) )
