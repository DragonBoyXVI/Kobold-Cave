
extends ScalieResource
class_name LedgeGrabInfo
## Container for data related to ledge grabbing
##
## ditto


## what kind of ledge are we grabbing
enum TYPE {
	## teh shape child of a static body
	OBJECT,
	## a tile with collision
	TILE
}


func _to_string() -> String:
	
	const text := "LedgeGrabInfo\nType: {0}, Pos: {1}, Radius: {2}, Height: {3}"
	return text.format( [ grab_type, object_position, object_width_radius, object_top_position ] )


## the type of shape we are grabbing
var grab_type: TYPE

## the global position of the object
var object_position: Vector2
## the global y position of the objects top
var object_top_position: float
## the x width of the object, extends from the center like a circle radius
var object_width_radius: float
