@tool
extends PlayerState
class_name PlayerDead

const STATE_NAME := &"PlayerDead"


# play an anim in enter

func _physics_process( delta: float ) -> void:
	
	if ( player.is_on_floor() ):
		
		player.logic_walk( delta, 0.0 )
	else:
		
		player.routine_airborne( delta, Vector2.ZERO )
	
	player.move_and_slide()
