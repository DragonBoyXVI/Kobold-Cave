#@tool
extends PanelContainer
class_name ObjDescriptionBox
## displays description text after reciving a signal
##
## Using a signal in DragonRadio, plus a password system.
## This node will only display text from the signal if
## the provided password matches this one


const PASSWORD_SETTINGS := &"Settings"


## the password needed to display text here.
## if empty, all signals will be allowed.
@export var password: StringName = &""
## if true, this ignores all signals
@export var locked: bool = false

@export_group( "Innards" )
@export var label: Label


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	DragonRadio.description_display_me.connect( _on_radio_description_display_me )


func _on_radio_description_display_me( provided_text: String, provided_password: StringName ) -> void:
	
	if ( locked ): return
	if ( not password.is_empty() and password != provided_password ): return
	
	label.text = provided_text
