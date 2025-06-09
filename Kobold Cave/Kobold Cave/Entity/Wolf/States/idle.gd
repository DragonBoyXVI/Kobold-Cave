@tool
extends StateBehaviour
class_name StateWolfIdle

const STATE_NAME := &"StateWolfIdle"


@export var wolf: Wolf
@export var movement: MovementGround
@export var wait_time: float = 5.0
@export var wait_rand_dist: float = 1.25


var flip_on_leave: bool = false

var _wait_timer: SceneTreeTimer


func _enter( args: Dictionary ) -> void:
	
	const arg_flip := &"Flip on Leave"
	flip_on_leave = args[ arg_flip ]
	
	_wait_timer = get_tree().create_timer( randfn( wait_time, wait_rand_dist ), false, true )
	_wait_timer.timeout.connect( _on_wait_timer_timeout )

func _leave() -> void:
	
	if ( _wait_timer ):
		
		_wait_timer.set_block_signals( true )
		_wait_timer = null

func _physics_process( delta: float ) -> void:
	
	movement.logic_walk( wolf, delta, 0.0 )
	if ( wolf.velocity.length_squared() > 0.0 ):
		
		wolf.move_and_slide()
	
	if ( not wolf.is_on_floor() ):
		
		request_state( StateWolfAir.STATE_NAME )


func _on_wait_timer_timeout() -> void:
	
	if ( flip_on_leave ):
		
		wolf.is_facing_right = not wolf.is_facing_right
		flip_on_leave = false
	
	request_state( StateWolfMarch.STATE_NAME )
