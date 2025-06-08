# based on a tutorial by nathan hoad
@tool
extends PanelContainer
class_name TestMenu


## emitted when the user hits enter on an item.
## provides the item that was selected
signal actioned( item: Control )


@export var pointer: Control
## the child container that actually contains items
@export var item_container: Control = self:
	set( new ):
		
		if ( new ):
			
			item_container = new
		else:
			
			item_container = self
		
		update_configuration_warnings()


## child nodes that are considered menu items
var menu_items: Array[ Control ] = []


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not item_container ):
		
		const text := "Needs to refrence a control that holds menu items!"
		warnings.append( text )
	
	return warnings

func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return
	
	visibility_changed.connect( _on_visibility_changed )
	
	actioned.connect( func( node: Control ) -> void: print( node.name ) )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		set_process_unhandled_input( false )
		return
	
	get_window().gui_focus_changed.connect( _on_window_gui_focus_changed )
	
	find_items_in_node( item_container )
	configure_items_focus()
	
	print( item_container.owner.name )

func _unhandled_input( event: InputEvent ) -> void:
	
	var item: Control = get_focused_item()
	if ( not is_instance_valid( item ) ): return
	
	if ( event.is_action_pressed( &"Enter" ) ):
		
		actioned.emit( item )
		accept_event()
		return


## searches children of the node and adds any items to the [menu_items][br]
func find_items_in_node( node: Node = self ) -> void:
	
	for child: Node in node.get_children():
		if child is not Control: continue
		
		if "Heading" in child.name: continue
		if "Divider" in child.name: continue
		
		if ( not menu_items.has( child ) ):
			
			menu_items.append( child )

## auto sets up item focus
func configure_items_focus() -> void:
	
	for i: int in menu_items.size():
		var item: Control = menu_items[ i ]
		
		item.focus_mode = Control.FOCUS_ALL
		
		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()
		
		if ( i == 0 ):
			
			item.grab_focus.call_deferred()
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
		else:
			
			item.focus_neighbor_top = menu_items[ i - 1 ].get_path()
			item.focus_previous = item.focus_neighbor_top
		
		if ( i == ( menu_items.size() - 1 ) ):
			
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = item.get_path()
		else:
			
			item.focus_next = menu_items[ i + 1 ].get_path()
			item.focus_neighbor_bottom = item.focus_next

## returns a [Control] if the focused item is an item
## of this menu. Returns null otherwise
func get_focused_item() -> Control:
	
	var item := get_viewport().gui_get_focus_owner()
	return item if menu_items.has( item ) else null

## sets the menu to focus on the focused item
func update_selection() -> void:
	
	var item: Control = get_focused_item()
	if ( pointer and item ):
		
		pointer.global_position = item.global_position
	pass


func _on_window_gui_focus_changed( gui_node: Control ) -> void:
	
	if ( not gui_node ): return
	if ( not menu_items.has( gui_node ) ): return
	
	update_selection()

func _on_visibility_changed() -> void:
	
	set_process_unhandled_input( is_visible_in_tree() )


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Control ):
		
		if ( item_container == self ):
			if ( node is Container and node is not TestMenu ):
				
				item_container = node
		else:
			if ( not item_container ):
				
				item_container = node
