@tool
extends SettingPanel
class_name ObjSettingOptionButton
## an option button that changes settings
##
## ditto


## used to translate the names of button items
@export_multiline var item_name_keys: PackedStringArray = []
## used to for description formatting
@export_multiline var item_desc_key: PackedStringArray = []

@export_group( "Innards" )
@export var default_button: Button
@export var option_button: OptionButton


func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	Settings.connect_changed_callback( _on_settings_updated, 0, setting_changer.setting_flags )
	
	default_button.pressed.connect( _on_default_button_pressed, CONNECT_DEFERRED )
	option_button.item_selected.connect( _on_option_button_item_selected )

func _notification( what: int ) -> void:
	super( what )
	
	match what:
		
		NOTIFICATION_TRANSLATION_CHANGED:
			
			if ( Engine.is_editor_hint() ):
				return
			
			if ( not is_node_ready() ):
				await ready
			
			set_button_translations()

func _desc_format( desc: String ) -> String:
	
	var format: String = "No String"
	if ( option_button.selected < item_desc_key.size() ):
		
		format = tr( item_desc_key[ option_button.selected ] )
	
	return desc % format


func set_button_translations() -> void:
	
	for i: int in mini( item_name_keys.size(), option_button.item_count ):
		
		var text: String = tr( item_name_keys[ i ] )
		option_button.set_item_text( i, text )


func _on_default_button_pressed() -> void:
	
	setting_changer.reset_setting()

func _on_option_button_item_selected( index: int ) -> void:
	
	emit_description()
	setting_changer.change_setting( option_button.get_item_id( index ) )

func _on_settings_updated( new_file: SettingsFile ) -> void:
	
	option_button.selected = option_button.get_item_index( new_file.get( setting_changer.setting_name ) )
