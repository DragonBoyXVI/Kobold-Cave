
extends Control
class_name PauseMenu
## The pause menu that appears when the tree is paused
##
## ditto


## node that had focus before game was paused
var had_focus_before_pause: Control

@export var settings_menu: DragonMenu
@export var desciption_box: ObjDescriptionBox


func _ready() -> void:
	
	DragonPauser.connect_to_pause( _on_tree_paused )
	settings_menu.visibility_changed.connect( _on_settings_menu_visibility_changed )
	
	hide()




func _on_tree_paused( is_paused: bool ) -> void:
	
	if ( is_paused ):
		
		had_focus_before_pause = get_window().gui_get_focus_owner()
		show()
	else:
		
		if ( had_focus_before_pause ):
			
			had_focus_before_pause.grab_focus.call_deferred()
			had_focus_before_pause = null
		
		Settings.notify_settings_changed()
		Settings.save_file()
		hide()


func _on_button_resume_pressed() -> void:
	
	DragonPauser.toggle_pause()


func _on_settings_menu_visibility_changed() -> void:
	
	desciption_box.visible = settings_menu.is_visible_in_tree()
