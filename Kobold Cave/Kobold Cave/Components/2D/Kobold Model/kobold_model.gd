@tool
extends DragonModel2D
class_name KoboldModel2D


@export var footstep_mark: Marker2D:
	set( new ):
		
		footstep_mark = new
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not footstep_mark ):
		
		const text := "Footstep mark is needed to play footsteps"
		warnings.append( text )
	
	return warnings


func play_footstep_sound() -> void:
	
	KoboldRadio.play_footstep.emit( footstep_mark.global_position )
