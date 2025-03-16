
extends StateBehaviour
class_name StateWolfMarch

const STATE_NAME := &"MarchForeward"


@export var wolf: Wolf
@export var pivot: Node2D

@export var ray_floor: RayCast2D
@export var ray_wall: RayCast2D


func _physics_process( delta: float ) -> void:
	
	var dir: float = 1.0 * pivot.scale.x
	wolf.logic_walk( delta, dir )
	wolf.move_and_slide()
	
	if ( not wolf.is_on_floor() ):
		
		request_state( StateWolfAir.STATE_NAME )
	
	if ( ray_wall.is_colliding() or not ray_floor.is_colliding() ):
		
		request_state( StateWolfIdle.STATE_NAME, { &"Flip on Leave": true } )
