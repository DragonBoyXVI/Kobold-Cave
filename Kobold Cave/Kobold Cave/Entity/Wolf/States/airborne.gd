@tool
extends StateBehaviour
class_name StateWolfAir


const STATE_NAME := &"StateWolfAir"


@export var wolf: Wolf
@export var movement: MovementGround


var dir_leaving_ground: float = 0.0


func _physics_process( delta: float ) -> void:
	
	var resist_dir: float = dir_leaving_ground * -1.0
	movement.routine_airborne( wolf, delta, Vector2( resist_dir, 0.0 ) )
	wolf.move_and_slide()
	
	if ( wolf.is_on_floor() ):
		
		request_state( StateWolfMarch.STATE_NAME, { &"Flip on Leave": false } )
