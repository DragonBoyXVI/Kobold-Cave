@tool
extends StateBehaviour
class_name StateWolfAir


const STATE_NAME := &"StateWolfAir"


@export var wolf: Wolf
@export var movement: MovementGround


var dir_leaving_ground: float = 0.0


func _enter( _args: Dictionary ) -> void:
	
	wolf.model.animation_player.play( KoboldModel2D.ANIM_FALL )

func _physics_process( delta: float ) -> void:
	
	var resist_dir: float = dir_leaving_ground * -1.0
	movement.routine_airborne( wolf, delta, Vector2( resist_dir, 0.0 ) )
	wolf.move_and_slide()
	
	if ( wolf.is_on_floor() ):
		
		request_state( StateWolfIdle.STATE_NAME, { 
			StateWolfIdle.ARG_FLIP_ON_LEAVE: ( Engine.get_physics_frames() % 2 == 0 ),
			StateWolfIdle.ARG_WAIT_TIME_MULT: 0.125
	} )
