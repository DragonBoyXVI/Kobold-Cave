@tool
extends StateBehaviour
class_name StateWolfMarch

const STATE_NAME := &"StateWolfMarch"


@export var wolf: Wolf
@export var movement: MovementGround

@export_group( "Rays", "ray_" )
@export var ray_floor_right: RayCast2D
@export var ray_wall_right: RayCast2D
@export var ray_floor_left: RayCast2D
@export var ray_wall_left: RayCast2D


func _enter( _args: Dictionary ) -> void:
	
	wolf.model.animation_player.play( KoboldModel2D.ANIM_RUN )

func _physics_process( delta: float ) -> void:
	
	var dir: float = 1.0 if wolf.is_facing_right else -1.0
	movement.logic_walk( wolf, delta, dir )
	wolf.move_and_slide()
	
	if ( not wolf.is_on_floor() ):
		
		request_state( StateWolfAir.STATE_NAME )
	
	var ray_wall: RayCast2D = ray_wall_right if wolf.is_facing_right else ray_wall_left
	var ray_floor: RayCast2D = ray_floor_right if wolf.is_facing_right else ray_floor_left
	
	if ( ray_wall.is_colliding() or not ray_floor.is_colliding() ):
		
		request_state( StateWolfIdle.STATE_NAME, { 
			StateWolfIdle.ARG_FLIP_ON_LEAVE: true 
		} )
