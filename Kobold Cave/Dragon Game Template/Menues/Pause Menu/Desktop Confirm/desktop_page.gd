extends MarginContainer


signal said_no


func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_VISIBILITY_CHANGED:
			
			if ( visible ):
				
				( %NoButton as Control ).grab_focus.call_deferred()


func _on_no_button_pressed() -> void:
	
	said_no.emit()

func _on_yes_button_pressed() -> void:
	
	DragonRadio.tree_quited.emit()
	get_tree().quit.call_deferred()
