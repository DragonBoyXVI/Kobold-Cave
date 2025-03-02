@tool
extends Entity
class_name Wolf


var facing_right := true


func set_facing( right: bool ) -> void:
	
	# is there a cleaner way of doing this than fucking with 
	# the collision scale? probably
	facing_right = right
	if ( right ):
		
		scale.x = 1.0
	else:
		
		scale.x = -1.0
