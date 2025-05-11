@tool
extends TriggerResponse
class_name TriggerGiveSecret


@export var secret_to_give: SaveFile.SECRETS = SaveFile.SECRETS.NO_SECRET


func _init() -> void:
	super()
	
	disable_when_ticked = true
	disable_at_tick = 1
	disable_tick_time = 0b1
	
	parent_respect_leave = false


func _player_enterd( _player: Player ) -> void:
	
	print( "found secret: ", secret_to_give )
	print( "this does nothing for now" )
