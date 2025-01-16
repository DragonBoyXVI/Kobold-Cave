extends StateBehaviour


var node_to_follow: Node2D


func _process( delta: float ) -> void:
	if ( not node_to_follow ): return
	
	MainCamera2D.routine_camera( node_to_follow.global_position, delta )
