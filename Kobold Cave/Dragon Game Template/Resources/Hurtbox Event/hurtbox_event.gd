@icon( "res://Dragon Game Template/Icons/Hurtbox Events/hurtbox_event_abstract.png" )
extends ScalieResource
class_name HurtboxEvent
## Used by [Hurtbox2D] and [Hurtbox3D] to send info to a [NodeHealth]
##
## This base class is used by hurtboxes to pass information to
## a [NodeHealth] when they strike a valid [Hitbox2D] or [Hitbox3D].[br]
## NOTE: Hurtboxes supply a copy of this resource, as they systems
## they interact with change the data within the resource.


func _to_string() -> String:
	
	return "HurtboxEvent, not meant to be used directly"


## called by [NodeHealth] to apply this to itself
func apply( _health_node: NodeHealth ) -> void:
	
	push_error( "NOT IMPLIENTED: HurtboxEvent.apply()", self )

## sometimes you want something as a color. This is that time.
func to_color() -> Color:
	
	return _to_color()


## virtual for what color this should turn into
func _to_color() -> Color:
	
	push_error( "NOT IMPLIENTED: HurtboxEvent._to_color()", self )
	return Color.YELLOW
