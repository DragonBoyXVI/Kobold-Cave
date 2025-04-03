@tool
extends PlayerState
class_name PlayerDead

const STATE_NAME := &"PlayerDead"


# play an anim in enter

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	player.health_node.revived.connect( _on_revived )

func _physics_process( delta: float ) -> void:
	
	if ( player.is_on_floor() ):
		
		movement.logic_walk( player, delta, 0.0 )
	else:
		
		movement.routine_airborne( player, delta, Vector2.ZERO )
	
	player.move_and_slide()



func _on_revived() -> void:
	if ( not can_process() ): return
	
	request_state( PlayerAir.STATE_NAME )
