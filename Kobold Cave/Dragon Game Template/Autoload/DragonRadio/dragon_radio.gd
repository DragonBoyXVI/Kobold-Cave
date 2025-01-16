extends Node
## global signals for DragonTemplate use
## i would use another radio for your own game use.


## emmited when widgets want to sync data
signal widget_sync( property: StringName, value: Variant )


## emitted when a description is needed in a desc box
signal description_box_text( for_text: String, password: StringName )


## emitted when the user wishes to return to the main menu
signal main_menu_requested

## When get_tree().quit() is called, must emit yourself
signal tree_quited
