@tool
extends Control
class_name HUD
## displays health and bomb count
##
## ditto

const corner_offset_amount: float = 5.0
const corner_offset_direction: PackedVector2Array = [
	Vector2( 1.0, 1.0 ),
	Vector2( -1.0, 1.0 ),
	Vector2( 1.0, -1.0 ),
	Vector2( -1.0, -1.0 )
]
enum CORNERS {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}
