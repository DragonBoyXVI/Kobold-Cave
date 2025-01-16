@tool
extends SettingWidgetBase
class_name SettingWidgetOptionButton
## an option button that changes a setting
##
## ditto


@export_group( "Components" )
@export var option_button: OptionButton :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		option_button = value


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not option_button ):
		
		const text := "Please provide an option button."
		warnings.append( text )
	
	return warnings


func _is_property_valid( value: Variant ) -> bool:
	const valid_types: Array[ int ] = [
		TYPE_INT
	]
	
	return valid_types.has( typeof( value ) )

func _enabled( enable: bool ) -> void:
	
	option_button.disabled = not enable
	( %DefaultButton as Button ).disabled = not enable

func _settings_loaded( value: Variant ) -> void:
	
	option_button.selected = value

func _sync( value: Variant ) -> void:
	
	option_button.selected = value


func _on_option_button_item_selected( index: int ) -> void:
	
	change_setting( index )

func _on_default_button_pressed() -> void:
	
	var value := Settings.defaults.get( setting_property ) as int
	option_button.select( value )
	option_button.item_selected.emit( value )
