
extends AreaTrigger2D
class_name TriggerGiveBombs
## gives the player bombs when they enter the area
##
## ditto


func _player_entered( player: Player ) -> void:
	
	player.bomb_thrower.refill()

func _player_left( player: Player ) -> void:
	
	player.bomb_thrower.refill()
