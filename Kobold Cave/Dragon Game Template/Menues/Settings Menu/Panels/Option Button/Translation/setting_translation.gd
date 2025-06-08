@tool
extends ObjSettingOptionButton
class_name ObjTranslationButton
## chnages game translation
##
## dittor



func _notification( what: int ) -> void:
	super( what )
	
	if ( what == NOTIFICATION_TRANSLATION_CHANGED ):
		
		if ( Engine.is_editor_hint() ): return
		
		if ( not is_node_ready() ): 
			await ready
		
		option_button.selected = TranslationServer.get_loaded_locales().find( TranslationServer.get_locale() )

func set_button_translations() -> void:
	
	var locales: PackedStringArray = TranslationServer.get_loaded_locales()
	option_button.clear()
	
	for i: int in locales.size():
		
		var locale: String = locales[ i ]
		option_button.add_item( "[" + locale + "] " + TranslationServer.get_locale_name( locale ) )

func _desc_format( desc: String ) -> String:
	
	return desc % TranslationServer.get_language_name( TranslationServer.get_locale() )

func _on_option_button_item_selected( index: int ) -> void:
	
	emit_description()
	var new_locale: String = TranslationServer.get_loaded_locales()[ index ]
	setting_changer.change_setting( new_locale )
	option_button.set_deferred( &"selected", index )

func _on_settings_updated( _new_file: SettingsFile ) -> void:
	pass
