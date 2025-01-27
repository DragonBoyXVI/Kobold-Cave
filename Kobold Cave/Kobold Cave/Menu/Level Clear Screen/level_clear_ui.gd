
extends Control


func _ready() -> void:
	
	hide()
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )


func _on_radio_goal_touched() -> void:
	
	show()
