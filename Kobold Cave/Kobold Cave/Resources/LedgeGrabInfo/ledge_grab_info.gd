@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends RefCounted
class_name LedgeGrabInfo
## Container for data related to ledge grabbing
##
## ditto


func _to_string() -> String:
	
	const text := "LedgeGrabInfo"
	return text


## the global coord to grab
var grab_position: Vector2

## if true, the ledge is to the right side of the player
var grab_to_the_right: bool
