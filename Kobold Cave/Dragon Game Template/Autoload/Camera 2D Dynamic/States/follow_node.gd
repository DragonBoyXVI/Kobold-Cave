
extends StateBehaviour


@export var camera: Camera2D

var node_to_follow: Node2D


func _enter( args: Array ) -> void:
	
	if ( args[ 0 ] is Node2D ):
		
		node_to_follow = args[ 0 ]
	else:
		
		push_error( "Camera2D was not provided with a valid follow node" )

func _process( _delta: float ) -> void:
	
	if ( not node_to_follow ): return
	
	camera.position = node_to_follow.global_position
