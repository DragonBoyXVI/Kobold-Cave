
extends Node2D
class_name Level
## The area where a game loop takes place
## 
## ditto


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )



func pause() -> void:
	
	process_mode = PROCESS_MODE_DISABLED

func unpause() -> void:
	
	process_mode = PROCESS_MODE_INHERIT


func _test() -> void:
	
	#propagate_notification()
	
	pass


func _on_radio_goal_touched() -> void:
	
	pause()
