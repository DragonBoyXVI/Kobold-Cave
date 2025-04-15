@tool
extends TriggerResponse
class_name TriggerPush
## push the player in a direction
## 
## ditto


## If suppled a ref marker, the player is pushed 
## toward the marker 
@export var push_marker: Marker2D:
	set( new_marker ):
		
		push_marker = new_marker
		notify_property_list_changed()
## the force to apply in pix/second
@export var force: float = 800.0
## a vector for what direction to push in
var push_vector: Vector2 = Vector2.UP:
	
	set( value ):
		
		push_vector = value.normalized()


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( not push_marker ):
		
		properties.append( {
			"name": "push_vector",
			"type": TYPE_VECTOR2,
		} )
	
	return properties

func _init() -> void:
	super()
	
	parent_respect_leave = false


func _player_enter( player: Player ) -> void:
	
	var dir: Vector2 = push_vector
	if ( push_marker ):
		
		var angle: float = player.position.angle_to_point( push_marker.global_position )
		dir = Vector2.from_angle( angle )
	
	player.velocity += dir * force

func _player_leave( player: Player ) -> void:
	
	_player_enter( player )


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Marker2D ):
		
		push_marker = node
