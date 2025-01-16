@tool
extends TabContainer
class_name DragonTabs
## Provides a basic user interface for navigating tabs.
##
## Provides some simple effects, like a built in sound effect
## manager and the ability to change tabs with the bumbers


## when true, this will grab focus for its tab bar when it
## becomes visible
@export var auto_focus := false
## when true, return to tab 0 when turned visible
@export var auto_reset := true

## translation strings to use for tabs
@export var trans_strings: PackedStringArray : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		trans_strings = value

@export_group( "Audio", "audio_" )
## the audio player used to play audio
@export var audio_player: AudioStreamPlayer : 
	set( value ):
		notify_property_list_changed.call_deferred()
		update_configuration_warnings.call_deferred()
		
		audio_player = value
@export_subgroup( "Pitch", "pitch_" )
## if enabled, the pitch of the played sound effect will
## increase as you reach the final tab
var pitch_enabled := true :
	set( value ):
		notify_property_list_changed.call_deferred()
		
		pitch_enabled = value
## minimum sound effect pitch
var pitch_min := 1.0
## maximun sound effect pitch (played when you select the last tab)
var pitch_max := 2.0

## internal translation
var _translation: int


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( tabs_visible ):
		
		if ( trans_strings.size() < get_tab_count() ):
			
			const text := "Not enough translation strings. Translations may not work."
			warnings.append( text )
	
	return warnings

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( audio_player ):
		
		properties.append( {
			"name": "Pitch",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_SUBGROUP,
			"hint_string": "pitch_"
		} )
		
		properties.append( {
			"name": "pitch_enabled",
			"type": TYPE_BOOL,
		} )
		
		if ( pitch_enabled ):
			
			properties.append( {
				"name": "pitch_min",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.05,1.0,0.01"
			} )
			
			properties.append( {
				"name": "pitch_max",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "2.0,5.0,0.01"
			} )
	
	return properties

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"pitch_enabled",
		"pitch_min",
		"pitch_max"
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		
		&"pitch_enabled": return true
		&"pitch_min": return 1.0
		&"pitch_max": return 2.0
	
	return null

func _ready() -> void:
	
	tab_changed.connect( _on_tab_changed )
	
	if ( Engine.is_editor_hint() ): 
		
		child_order_changed.connect( update_configuration_warnings, CONNECT_DEFERRED )
		return
	
	get_tab_bar().mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	visibility_changed.connect( _on_visiblility_changed )
	Settings.updated_translation.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated.connect( _on_settings_updated, CONNECT_DEFERRED )

func _input( event: InputEvent ) -> void:
	
	if ( not tabs_visible ): return
	if ( not is_visible_in_tree() ): return
	
	
	if ( event.is_action_pressed( &"Menu Tab Left" ) ):
		
		current_tab = wrapi( current_tab - 1, 0, get_tab_count() )
		grab_tabs_focus.call_deferred()
		accept_event()
		return
	
	if ( event.is_action_pressed( &"Menu Tab Right" ) ):
		
		current_tab = wrapi( current_tab + 1, 0, get_tab_count() )
		grab_tabs_focus.call_deferred()
		accept_event()
		return


## plays a sound effect from the audio stream player
func play_sfx() -> void:
	
	if ( not audio_player ): return
	
	if ( pitch_enabled ):
		
		# plus one so the initial sound is different 
		# for every tab amount, instead of the end
		var tab_pos: float = float( current_tab + 1 ) / get_tab_count()
		var desired_pitch: float = lerpf( pitch_min, pitch_max, tab_pos )
		
		audio_player.pitch_scale = desired_pitch
		audio_player.play(  )
	else:
		
		audio_player.play(  )

## grabs control focus on the tabs
func grab_tabs_focus() -> void:
	
	get_tab_bar().grab_focus()

## updates the translation of tabs
func translate_tabs() -> void:
	
	var tab_number := mini( get_tab_count(), trans_strings.size() )
	for index: int in tab_number:
		
		set_tab_title( index, tr( trans_strings[ index ] ) )


func _on_tab_changed( _tab: int ) -> void:
	
	play_sfx()

func _on_visiblility_changed(  ) -> void:
	
	if ( is_visible_in_tree() ):
		
		if ( auto_reset ):
			
			current_tab = 0
		
		if ( auto_focus ):
			
			grab_tabs_focus.call_deferred()

func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	if ( not tabs_visible ): return
	
	if ( _translation == recived_data.translation ): return
	_translation = recived_data.translation
	
	translate_tabs()
