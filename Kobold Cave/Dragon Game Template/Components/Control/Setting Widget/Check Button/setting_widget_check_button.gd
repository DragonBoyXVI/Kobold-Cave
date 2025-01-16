@tool
extends SettingWidgetBase
class_name SettingWidgetCheckButton
## A [CheckButton] that edits a setting
##
## ditto


@export_group( "Components" )
@export var check_button: CheckButton :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		check_button = value


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not check_button ):
		
		const text := "please provide the [CheckButton]"
		warnings.append( text )
	
	return warnings


func _enabled( enabled: bool ) -> void:
	
	check_button.disabled = not enabled

func _settings_loaded( value: Variant ) -> void:
	
	check_button.set_pressed_no_signal( value )

func _sync( value: Variant ) -> void:
	
	check_button.set_pressed_no_signal( value )

func _is_property_valid( value: Variant ) -> bool:
	const valid_types: Array[ int ] = [
		TYPE_BOOL
	]
	
	return valid_types.has( typeof( value ) )


func _on_check_button_toggled( toggled_on: bool ) -> void:
	
	change_setting( toggled_on )
