
extends TextureRect
class_name CursorNode


var last_node: Control


func _init() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	
	get_window().gui_focus_changed.connect( _on_gui_focus_changed )


func _on_gui_focus_changed( node: Control ) -> void:
	
	if ( not is_instance_valid( node ) ): return
	if ( node == last_node ): return
	
	


func enable() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	show()

func disable() -> void:
	
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
