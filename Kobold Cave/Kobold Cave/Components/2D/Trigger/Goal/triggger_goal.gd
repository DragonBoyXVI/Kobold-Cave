
extends AreaTrigger2D
class_name TriggerGoal
## Touch this to end the level
##
## ditto


func _player_entered( _player: Player ) -> void:
	
	KoboldRadio.goal_touched.emit()
