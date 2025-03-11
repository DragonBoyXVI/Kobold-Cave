@tool
extends TriggerResponse
class_name TriggerSetSpawn
## sets your spawn point
##
## ditto


@export var spawn: Marker2D:
	set( new_spawn ):
		
		spawn = new_spawn
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not spawn ):
		
		const text := "Has no spawn marker, give it one!"
		warnings.append( text )
	
	if ( editor_is_enter_callable() ):
		
		const text := "If this cant run enter, then the spawn wont be set."
		warnings.append( text )
	
	return warnings

func _init() -> void:
	
	parent_respect_leave = false
	disable_when_ticked = true
	disable_at_tick = 1
	disable_tick_time = 3


func _player_enter( _player: Player ) -> void:
	
	KoboldRadio.level_set_spawn.emit( spawn )
