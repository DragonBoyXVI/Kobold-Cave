
extends KCResource
class_name LedgeGrabInfo
## Container for data related to ledge grabbing
##
## ditto


func _to_string() -> String:
	
	const text := "LedgeGrabInfo"
	return text


## your global coords when you grabbed
var my_position: Vector2

## the global coord to grab
var grab_position: Vector2

## if true, the ledge is to the right side of the player
var grab_to_the_right: bool

## the node we grabbed, could be a [TileMapLayer], or any [CollisionBody2D]
var grabbed_node: Node2D
