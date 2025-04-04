
# no ai request for the state machine?
extends StateBehaviour


@export var ghost: ExplodingGhost
@export var movement: MovementFlying


func _physics_process( delta: float ) -> void:
	
	movement.logic_fly_in_place( ghost, delta )
	ghost.move_and_slide()

func _on_area_see_player_body_entered( body: Node2D ) -> void:
	
	if ( not can_process() ): return
	if ( body is not Player ): return
	
	request_state( &"FollowPlayer", { &"Player": body } )
