
extends BoxContainer
class_name MenuFocusSorter
## A [BoxContainer] that sorts the focus of its children
##
## ditto


## if true, this grabs focus when it becomes visible
@export var auto_focus: bool = false
## first item in this menu, gets focused when the container gets focus
var _first_borne: Control


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	focus_mode = Control.FOCUS_ALL
	visibility_changed.connect( _on_visibility_changed )
	focus_entered.connect( _on_focus_entered )
	child_order_changed.connect( _on_child_order_changed )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	set_children_focus()


## sets the focus neighbors of children
func set_children_focus() -> void:
	
	var children: Array[ Node ] = get_children().filter( _child_filter )
	for i: int in children.size():
		var child: Control = children[ i ]
		
		child.focus_mode = Control.FOCUS_ALL
		
		if ( i == 0 ):
			
			_first_borne = child
		else:
			
			child.focus_previous = children[ i - 1 ].get_path()
			if ( vertical ):
				
				child.focus_neighbor_top = child.focus_previous
			else:
				
				child.focus_neighbor_left = child.focus_previous
		
		if ( i == ( children.size() - 1 ) ):
			
			pass
		else:
			
			child.focus_next = children[ i + 1 ].get_path()
			if ( vertical ):
				
				child.focus_neighbor_bottom = child.focus_next
			else:
				
				child.focus_neighbor_right = child.focus_next
	
	focus_mode = FOCUS_ALL if children.size() > 0 else FOCUS_NONE

func _child_filter( node: Node ) -> bool:
	
	return node is Control and node is not Label

var _child_sort_pending: bool = false
func _on_child_order_changed() -> void:
	
	if ( not is_inside_tree() ): return
	if ( _child_sort_pending ): return
	
	# done so that only one sort is needed per frame
	_child_sort_pending = true
	await get_tree().process_frame
	_child_sort_pending = false
	
	set_children_focus()

func _on_visibility_changed() -> void:
	
	if ( auto_focus ):
		if ( is_visible_in_tree() ):
			
			grab_focus.call_deferred()

func _on_focus_entered() -> void:
	
	if ( _first_borne ):
		
		_first_borne.grab_focus.call_deferred()
