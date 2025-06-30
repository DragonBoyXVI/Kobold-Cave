
extends Control
class_name GUIRoot
## root for gui stuff
##
## ditto


func _init() -> void:
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _notification( what: int ) -> void:
	
	if ( what == NOTIFICATION_UNPAUSED or what == NOTIFICATION_PAUSED ):
		
		var children: Array[ Node ] = get_children().filter( _filter_control )
		for child: Control in children:
			
			DragonUIAnimations.fade_control( child, child.can_process() )


func _filter_control( node: Node ) -> bool: return node is Control


## uses add_child() and move_child() to place children
func add_child_by_index( child: Node, index: int ) -> void:
	
	add_child( child )
	move_child( child, index )
