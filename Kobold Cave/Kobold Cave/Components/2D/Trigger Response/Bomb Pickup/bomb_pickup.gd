@tool
extends TriggerResponse
class_name TriggerBombPickup
## refills the players bombs
##
## ditto

func _player_enter( player: Player ) -> void:
	
	player.bomb_thrower.refill()

func _player_leave( player: Player ) -> void:
	
	player.bomb_thrower.refill()
