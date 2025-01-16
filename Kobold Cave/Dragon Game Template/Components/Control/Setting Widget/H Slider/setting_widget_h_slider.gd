@tool
extends SettingWidgetBase
class_name SettingWidgetHSlider
## An [Hslider] that edits a setting.
## 
## A slider widget that lets you edit a setting.
## multiple [Range] nodes can be included, but we should only listen to
## the slider nodes signals


## this is here for the volume sliders to use lmao.
@export var audio_player: AudioStreamPlayer

@export_group( "Components" )
@export var spin_box: SpinBox :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		spin_box = value
@export var slider: HSlider :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		slider = value


func _ready() -> void:
	super()
	
	if ( slider and spin_box ):
		
		slider.share( spin_box )
		spin_box.get_line_edit().focus_mode = Control.FOCUS_CLICK
	
	if ( Engine.is_editor_hint() ):
		return
	
	pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not spin_box ):
		
		const text := "Please provide a spin box."
		warnings.append( text )
	
	if ( not slider ):
		
		const text := "Please provide a slider. Thats like the whole point of this thinh"
		warnings.append( text )
	
	return warnings


func _enabled( enable: bool ) -> void:
	
	slider.editable = enable
	spin_box.editable = enable
	
	%DefaultButton.disabled = not enable

func _is_property_valid( value: Variant ) -> bool:
	const valid_types: Array[ int ] = [
		TYPE_FLOAT,
		TYPE_INT
	]
	
	return valid_types.has( typeof( value ) )

func _settings_loaded( value: Variant ) -> void:
	
	slider.set_value_no_signal( value )

func _sync( value: Variant ) -> void:
	
	slider.set_value_no_signal( value )


func _on_h_slider_value_changed( value: float ) -> void:
	
	change_setting( value )
	
	if ( audio_player ):
		
		audio_player.play()

func _on_default_button_pressed() -> void:
	
	if ( not _property_is_valid ):
		return
	
	var value: Variant = Settings.defaults.get( setting_property )
	# slider takes care of the update
	slider.value = value
