
extends Control


func _ready() -> void:
	
	hide()
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )


func _on_radio_goal_touched() -> void:
	
	show()


func _on_next_button_pressed() -> void:
	
	hide()
	KoboldRadio.level_clear_next_pressed.emit()
