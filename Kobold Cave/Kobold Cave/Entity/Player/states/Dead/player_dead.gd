@tool
extends PlayerState
class_name PlayerDead

const STATE_NAME := &"PlayerDead"


func _enter( _args: Dictionary ) -> void:
	
	model.animation_player.play( KoboldModel2D.ANIM_DEAD )

func _physics_process( delta: float ) -> void:
	
	if ( player.is_on_floor() ):
		
		movement.logic_walk( player, delta, 0.0 )
	else:
		
		movement.routine_airborne( player, delta, Vector2.ZERO )
	
	player.move_and_slide()



func _on_revived() -> void:
	if ( not can_process() ): return
	
	request_state( PlayerAir.STATE_NAME )
