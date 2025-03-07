

extends StateBehaviour


@export var ghost: ExplodingGhost


func _on_area_see_player_body_entered( body: Node2D ) -> void:
	
	if ( not can_process() ): return
	if ( body is not Player ): return
	
	request_state( &"FollowPlayer", [ body ] )
