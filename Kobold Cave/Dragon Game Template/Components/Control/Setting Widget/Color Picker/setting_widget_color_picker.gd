@tool
extends SettingWidgetBase
class_name SettingWidgetColorPicker
## Setting widget that lets you change the color of something
## 
## ditto


@export_group( "Components" )
@export var color_picker_button: ColorPickerButton :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		color_picker_button = value


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not color_picker_button ):
		
		const text := "Please provide a color picker button"
		warnings.append( text )
	
	return warnings


func _is_property_valid( value: Variant ) -> bool:
	const valid_types: Array[ int ] = [
		TYPE_COLOR
	]
	
	return valid_types.has( typeof( value ) )

func _enabled( enable: bool ) -> void:
	
	color_picker_button.disabled = not enable
	( %DefaultButton as Button ).disabled = not enable

func _settings_loaded( value: Variant ) -> void:
	
	color_picker_button.color = value

func _sync( value: Variant ) -> void:
	
	color_picker_button.color = value


func _on_color_picker_button_color_changed( color: Color ) -> void:
	
	change_setting( color )

func _on_default_button_pressed() -> void:
	
	var value: Variant = Settings.defaults.get( setting_property )
	change_setting( value )
	color_picker_button.color = value
