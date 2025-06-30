@tool
extends DragonModel2D
class_name KoboldModel2D


const ANIM_RUN := &"Run"
const ANIM_IDLE := &"Idle"

const ANIM_RUN_CROUCHED_FORWARD := &"RunCrouchedForward"
const ANIM_RUN_CROUCHED_BACKWARD := &"RunCrouchedBackward"
const ANIM_IDLE_CROUCHED := &"IdleCrouched"

const ANIM_FALL := &"Fall"
const ANIM_JUMP := &"Jump"

const ANIM_HURT := &"Stun"
const ANIM_DEAD := &"Dead"

const ANIM_LEDGE_HANG := &"LedgeHang"
const ANIM_LEDGE_JUMP := &"LedgeJump"


@export var footstep_mark: Marker2D:
	set( new ):
		
		footstep_mark = new
		update_configuration_warnings()


var is_facing_right: bool = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not footstep_mark ):
		
		const text := "Footstep mark is needed to play footsteps"
		warnings.append( text )
	
	return warnings


func play_footstep_sound() -> void:
	
	KoboldRadio.play_footstep.emit( footstep_mark.global_position )

func set_facing_right( facing_right: bool, turn_time: float = 0.15 ) -> void:
	
	if ( is_facing_right == facing_right ): return
	
	is_facing_right = facing_right
	
	var target_scale: float = 1.0 if facing_right else -1.0
	
	var tween := create_tween()
	tween.tween_property( self, ^"scale:x", target_scale, turn_time )
