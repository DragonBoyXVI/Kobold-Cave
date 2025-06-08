@tool
@icon( "uid://dtskp8fwxafd1" )
extends Resource
class_name SettingChanger
## Resource used to edit settings
##
## ditto

## default settings, used for the default buttons
static var default_settings: SettingsFile = SettingsFile.new()


@export_group( "Setting", "setting_" )
## if true, calling change_setting will emit an update signal
@export var setting_emit_update: bool = false
## The name of the setting we want to change
var setting_name: StringName = &"dummy_property" :
	set( new ):
		
		if ( new.is_empty() ):
			
			new = &"dummy_property"
		else:
			
			setting_name = new
		
		emit_changed()

@warning_ignore("int_as_enum_without_match")
var setting_flags: Settings.UPDATE = 0 as Settings.UPDATE


@export var setting_type: Variant.Type = TYPE_FLOAT :
	set( new ):
		
		setting_type = new
		setting_name = &"dummy_property"
		notify_property_list_changed()
		emit_changed()


func _init( config_name: StringName = &"" ) -> void:
	
	if ( config_name.is_empty() ): return
	
	setting_type = typeof( default_settings.get( config_name ) ) as Variant.Type
	setting_name = config_name

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	#
	#properties.append( {
		#"name": "Setting",
		#"type": TYPE_NIL,
		#"usage": PROPERTY_USAGE_GROUP,
		#"hint_string": "setting_"
	#} )
	
	properties.append( {
		"name": "setting_name",
		"type": TYPE_STRING_NAME,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join( default_settings.get_settings_names( _setting_property_filter ) )
	} )
	
	properties.append( {
		"name": "setting_flags",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": DragonUtility.make_pretty_enum_keys( Settings.get_update_flags() )
	} )
	
	return properties


## used to change the setting value.[br]
func change_setting( value: Variant ) -> void:
	
	#if ( typeof( value ) != setting_type ):
		#
		#push_error( "SettingChanger.change_setting: provided wrong type" )
		#return
	
	Settings.current_file.set( setting_name, type_convert( value, setting_type ) )
	if ( setting_emit_update ):
		
		Settings.notify_settings_changed( setting_flags )

## used to reset a setting
func reset_setting() -> void:
	
	Settings.current_file.set( setting_name, default_settings.get( setting_name ) )
	if ( setting_emit_update ):
		
		Settings.notify_settings_changed( setting_flags )


func _setting_property_filter( item: Dictionary ) -> bool:
	
	return item[ "type" ] == setting_type
