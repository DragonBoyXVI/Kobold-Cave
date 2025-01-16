
extends PanelContainer
class_name DescriptionBox
## Display text, wow
##
## Displays text and uses a password system to limit
## what messages this can display


@export var my_password: StringName = &""
@onready var label := %Label as RichTextLabel


func _ready() -> void:
	
	
	DragonRadio.description_box_text.connect( _on_radio_description_box_text )


func set_text( for_text: String ) -> void:
	
	label.text = for_text


func _on_radio_description_box_text( for_text: String, password: StringName ) -> void:
	
	if ( my_password != password ):
		return
	
	set_text( for_text )
