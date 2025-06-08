@tool
extends StateBehaviour
class_name StateCam2DFollowNode


const STATE_NAME := &"FollowNode"
const ARG_FOLLOW_NODE := &"Follow Node"


@export var camera: Camera2D

var node_to_follow: Node2D


func _init() -> void:
	_internal_default_args = {
		ARG_FOLLOW_NODE: null
	}
	super()
	
	set_deferred( &"name", STATE_NAME )

func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	if ( args[ ARG_FOLLOW_NODE ] ):
		
		node_to_follow = args[ ARG_FOLLOW_NODE ]
		node_to_follow.tree_exiting.connect( _on_follow_node_exit_tree )
	else:
		
		push_error( "An invalid node was passed to camera, ", args[ ARG_FOLLOW_NODE ] )

func _leave() -> void:
	
	if ( node_to_follow ):
		
		node_to_follow.tree_exiting.disconnect( _on_follow_node_exit_tree )

func _process( _delta: float ) -> void:
	
	if ( not node_to_follow ): return
	
	camera.position = node_to_follow.global_position

func _change_is_valid( _new_state: StateBehaviour ) -> bool:
	
	return true

func _on_follow_node_exit_tree() -> void:
	
	request_state( NO_STATE )
