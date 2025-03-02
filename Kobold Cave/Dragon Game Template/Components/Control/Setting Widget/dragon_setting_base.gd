@tool
extends PanelContainer
class_name SettingWidgetBase
## provides some base functionality for setting widgets
##
## This [PanelContainer] handles some base functionality for
## what you would want a setting widget to do.


enum UPDATE_TYPE {
	## update fps and physics ticks
	TICK_SPEED,
	## update window size
	WINDOW,
	## update audio settings
	AUDIO,
	## update game translation
	TRANSLATION,
	## update camera
	CAMERA,
	
	## update everything
	ALL,
	## update nothing
	NONE
}


## what node to pass focus too when this is focused
@export var focus_me_node: Control :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		focus_me_node = value
## the description text
@export_group( "Description", "desc_" )
## the text
@export_multiline var desc_text: String = ""
## translate this text?
@export var desc_translate := false

@export_group( "Setting", "setting_" )
## The [SettingsFile] property this changes.
@export var setting_property: StringName :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		setting_property = value
## The settings update method to use
@export var setting_signal := UPDATE_TYPE.NONE

@export_group( "Pass Focus", "pass_focus_" )
## if this node has an up focus neighbor, pass that neighbor to these nodes
@export var pass_focus_up: Array[ Control ]
## if this node has a right focus neighbor, pass that neighbor to these nodes
@export var pass_focus_right: Array[ Control ]
## if this node has a down focus neighbor, pass that neighbor to these nodes
@export var pass_focus_down: Array[ Control ]
## if this node has a left focus neighbor, pass that neighbor to these nodes
@export var pass_focus_left: Array[ Control ]


## used for debugging
var _debug_settings: SettingsFile
## disable functionality if property is invalid
var _property_is_valid: bool


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		_debug_settings = SettingsFile.new()

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	
	_set_focus_neighbors.call_deferred()
	
	Settings.loaded.connect( _on_settings_loaded )
	Settings.widget_enabled.connect( _on_settings_widget_enabled, CONNECT_DEFERRED )
	
	DragonRadio.widget_sync.connect( _on_radio_widget_sync )

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_FOCUS_ENTER:
			
			update_description_text()
			
			if ( focus_me_node ):
				
				focus_me_node.grab_focus.call_deferred()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( focus_me_node == self ):
		
		const text := "focus me node cannot be yourself"
		push_error( name, ": ", text )
		warnings.append( text )
		
		focus_me_node = null
	
	
	_property_is_valid = true
	if ( setting_property.is_empty() ):
		
		_property_is_valid = false
		const text := "Please assign a [SettingsFile] property to this."
		warnings.append( text )
	elif ( setting_property != &"dummy_property" ):
		
		var value: Variant = _debug_settings.get( setting_property )
		if ( value == null ):
			
			_property_is_valid = false
			const text := "setting_property points to an invalid property."
			warnings.append( text )
		else:
			
			if ( not _is_property_valid( value ) ):
				
				_property_is_valid = false
				const text := "setting_property does not point to valid property.\nThe most likely cause is the value being an incorrect type."
				warnings.append( text )
	
	return warnings

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	# store this property for runtime usage
	properties.append( {
		"name": "_property_is_valid",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_NO_EDITOR
	} )
	
	return properties


## virtual function for checking to see if the assigned property is valid
func _is_property_valid( _value: Variant ) -> bool:
	
	return false

## virtual for what to do when this is enabled/disabled
func _enabled( _enable: bool ) -> void:
	pass

## virtual for what action to take when this wants to change a setting.
## by default you wont need to touch this.
func _change_setting( value: Variant ) -> void:
	
	Settings.data.set( setting_property, value )
	call_update()

## virtual for what to do when the settings are loaded
## and the value is retrived
func _settings_loaded( _value: Variant ) -> void:
	pass

## virtual for what to do when this recives a valid sync request
func _sync( _value: Variant ) -> void:
	pass


## calls an update from settings
func call_update() -> void:
	
	match setting_signal:
		
		UPDATE_TYPE.NONE:
			pass
		
		UPDATE_TYPE.ALL:
			Settings.update_all()
		
		UPDATE_TYPE.TICK_SPEED:
			Settings.update_tick_speed()
		
		UPDATE_TYPE.WINDOW:
			Settings.update_window_mode()
		
		UPDATE_TYPE.AUDIO:
			Settings.update_audio()
		
		UPDATE_TYPE.TRANSLATION:
			Settings.update_translation()
		
		UPDATE_TYPE.CAMERA:
			Settings.update_camera()

## calls for the description box text to update
func update_description_text() -> void:
	
	const password := &"settings"
	
	var new_text := desc_text
	if ( desc_translate ):
		
		new_text = tr( desc_text )
	
	DragonRadio.description_box_text.emit( new_text, password )

## changes the setting value
func change_setting( value: Variant ) -> void:
	
	if ( not _property_is_valid ):
		return
	
	if ( Engine.is_editor_hint() ):
		return
	
	_change_setting( value )
	DragonRadio.widget_sync.emit( setting_property, value )


## internal func for passing focus neigbors to child nodes
func _set_focus_neighbors() -> void:
	
	if ( focus_neighbor_top ):
		
		var node := get_node( focus_neighbor_top )
		for pass_to: Control in pass_focus_up:
			
			pass_to.focus_neighbor_top = pass_to.get_path_to( node )
	if ( focus_neighbor_right ):
		
		var node := get_node( focus_neighbor_right )
		for pass_to: Control in pass_focus_right:
			
			pass_to.focus_neighbor_right = pass_to.get_path_to( node )
	if ( focus_neighbor_bottom ):
		
		var node := get_node( focus_neighbor_bottom )
		for pass_to: Control in pass_focus_down:
			
			pass_to.focus_neighbor_bottom = pass_to.get_path_to( node )
	if ( focus_neighbor_left ):
		
		var node := get_node( focus_neighbor_left )
		for pass_to: Control in pass_focus_left:
			
			pass_to.focus_neighbor_left = pass_to.get_path_to( node )


func _on_settings_loaded( recived_data: SettingsFile ) -> void:
	
	if ( not _property_is_valid ):
		return
	
	var value: Variant = recived_data.get( setting_property )
	_settings_loaded( value )

func _on_settings_widget_enabled( property: StringName, enable: bool ) -> void:
	
	if ( property != setting_property ):
		return
	
	_enabled( enable )

func _on_radio_widget_sync( property: StringName, value: Variant ) -> void:
	
	if ( property == &"dummy_property" ): return
	
	if ( property != setting_property ):
		return
	
	# redundant?
	if ( not _is_property_valid( value ) ):
		return
	
	_sync( value )
