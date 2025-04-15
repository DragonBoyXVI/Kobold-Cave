@tool
extends TriggerResponse
class_name TriggerLevelClear
## finishes the level
##
## ditto


func _init() -> void:
	super()
	
	parent_respect_leave = false

func _player_enter( _player: Player ) -> void:
	
	KoboldRadio.goal_touched.emit()
