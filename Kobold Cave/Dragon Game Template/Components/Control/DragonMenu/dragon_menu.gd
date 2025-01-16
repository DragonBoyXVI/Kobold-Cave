@tool
extends MarginContainer
class_name DragonMenu
## A class that provides some convinent menu functions
##
## ditto


## the node that grabs focus when this wants focus
@export var initial_focus: Control :
	set( value ):
		
		if ( self == value ):
			return
		
		initial_focus = value


func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_VISIBILITY_CHANGED:
			
			if ( initial_focus ):
				if ( is_visible_in_tree() ):
					
					initial_focus.grab_focus.call_deferred()
