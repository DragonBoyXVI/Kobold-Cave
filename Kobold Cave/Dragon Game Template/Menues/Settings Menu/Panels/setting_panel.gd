@tool
extends PanelContainer
class_name SettingPanel
## Base for ui panels that edit settings
##
## ditto


## node to pass focus to when this is focused
@export var focus_node: Control
## the settings changer this uses
@export var setting_changer: SettingChanger:
	set( new ):
		
		setting_changer = new
		update_configuration_warnings()
## key used to get description text
@export_multiline var description_text: String = ""


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		if ( description_text == null ):
			description_text = ""
		return
	
	# because fuck me ig
	if ( not focus_entered.is_connected( _on_focus_entered ) ):
		focus_entered.connect( _on_focus_entered )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	get_window().gui_focus_changed.connect( _on_window_gui_focus_changed )

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not setting_changer ):
		
		const text := "SettingChanger needed to edit settings"
		warnings.append( text )
	
	return warnings

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_TRANSLATION_CHANGED:
			
			if ( Engine.is_editor_hint() ):
				return
			
			if ( not is_node_ready() ):
				await ready
			
			emit_description.call_deferred()


## sends out a description for a [ObjDescriptionBox] to show
func emit_description() -> void:
	
	var desc: String = tr( description_text )
	desc = _desc_format( desc )
	
	DragonRadio.description_display_me.emit( desc, ObjDescriptionBox.PASSWORD_SETTINGS )


## Virtual[br]
## gets fed the translated description for formatting
func _desc_format( desc_string: String ) -> String:
	
	return desc_string


func _on_window_gui_focus_changed( node: Control ) -> void:
	
	if ( is_ancestor_of( node ) ):
		
		emit_description()

func _on_focus_entered() -> void:
	
	if ( focus_node ):
		
		focus_node.grab_focus.call_deferred()
