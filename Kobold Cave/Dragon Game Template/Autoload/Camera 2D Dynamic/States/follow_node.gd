
extends StateBehaviour


@export var camera: Camera2D

var node_to_follow: Node2D


const ARG_NODE := &"Node"


func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	print( args )
	
	if ( args[ ARG_NODE ] is Node2D ):
		
		node_to_follow = args[ ARG_NODE ]
	else:
		
		node_to_follow = null
		print( "invalid follow node provided" )

func _process( _delta: float ) -> void:
	
	if ( not is_instance_valid( node_to_follow ) ): 
		
		request_state( &"NoBehaviour" )
		return
	
	camera.position = node_to_follow.global_position


func _change_is_valid( _new_state: StateBehaviour ) -> bool:
	
	return true
