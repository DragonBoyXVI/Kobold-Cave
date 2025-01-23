
extends KCResource
class_name LedgeGrabInfo
## Container for data related to ledge grabbing
##
## ditto


func _to_string() -> String:
	
	const text := "LedgeGrabInfo\nPos: {0}, To Right: {1}"
	return text.format( [ grab_position, grab_to_the_right ] )


## the global coord to grab
var grab_position: Vector2

## if true, the ledge is to the right side of the player
var grab_to_the_right: bool
