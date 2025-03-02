@tool
extends Entity
class_name Wolf


var facing_right := true


@onready var flip_pivot := %FlipPivot as Node2D

func set_facing( right: bool ) -> void:
	
	facing_right = right
	if ( right ):
		
		flip_pivot.scale.x = 1.0
	else:
		
		flip_pivot.scale.x = -1.0
