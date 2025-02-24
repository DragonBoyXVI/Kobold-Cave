@tool
extends AreaTrigger2D
class_name TriggerPush
## pushed the player in a direction when entered
##
## ditto


## if supplied, the player is pushed towards the marker
@export var ref_marker: Marker2D:
	set( value ):
		notify_property_list_changed.call_deferred()
		
		ref_marker = value
## how hard of a push to supply
@export var push_force: float = 1200.0
## a direction vector, we'll push the player in that dirction
var push_direction: Vector2 = Vector2.UP :
	set( value ):
		
		push_direction = value.normalized()


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( not ref_marker ):
		
		properties.append( {
			"name": "push_direction",
			"type": TYPE_VECTOR2
		} )
	
	return properties

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		child_entered_tree.connect( _util_child_entered_tree )
		return
	
	if ( ref_marker ):
		
		var angle := position.angle_to_point( ref_marker.position )
		push_direction = Vector2.from_angle( angle )


func _player_entered( player: Player ) -> void:
	
	player.velocity += push_direction * push_force


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Marker2D and not ref_marker ):
		
		ref_marker = node
