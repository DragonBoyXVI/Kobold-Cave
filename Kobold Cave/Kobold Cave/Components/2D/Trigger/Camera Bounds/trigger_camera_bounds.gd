
extends AreaTrigger2D
class_name TriggerCameraBounds
## used to changed camera bounds mid level
##
## Exports refs to [CameraBoundry] nodes and uses them to change
## the camera bounds when the player enters or leaves.[br]


@export var enter_bounds: Array[ CameraBoundry ] = []
@export var leave_bounds: Array[ CameraBoundry ] = []


func _player_entered( _player: Player ) -> void:
	
	for bound: CameraBoundry in enter_bounds:
		
		bound.activate()


func _player_left( _player: Player ) -> void:
	
	for bound: CameraBoundry in leave_bounds:
		
		bound.activate()
