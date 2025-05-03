
extends CollisionShape2D
class_name CollisionShape2DFlipping


var _is_facing_right: bool = true


func set_facing_right( facing_right: bool ) -> void:
	
	if ( facing_right == _is_facing_right ): return
	_is_facing_right = facing_right
	
	position.x *= -1.0
