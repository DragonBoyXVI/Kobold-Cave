@tool
extends StateBehaviour
class_name StateWolfIdle

const STATE_NAME := &"StateWolfIdle"

const ARG_FLIP_ON_LEAVE := &"Flip on Leave"
const ARG_WAIT_TIME_MULT := &"Wait Time Mult"


@export var wolf: Wolf
@export var movement: MovementGround
@export var wait_time: float = 5.0
@export var wait_rand_dist: float = 1.25


var flip_on_leave: bool = false

@export var wait_timer: Timer


func _init() -> void:
	
	_internal_default_args[ ARG_FLIP_ON_LEAVE ] = false
	_internal_default_args[ ARG_WAIT_TIME_MULT ] = 1.0
	super()

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	wait_timer.timeout.connect( _on_wait_timer_timeout )

func _enter( args: Dictionary ) -> void:
	
	flip_on_leave = args[ ARG_FLIP_ON_LEAVE ]
	
	wolf.model.animation_player.play( KoboldModel2D.ANIM_IDLE )
	
	wait_timer.start( randfn( wait_time, wait_rand_dist ) * args[ ARG_WAIT_TIME_MULT ] )

func _leave() -> void:
	
	if ( flip_on_leave ):
		
		wolf.is_facing_right = not wolf.is_facing_right
		flip_on_leave = false
	
	wait_timer.stop()

func _physics_process( delta: float ) -> void:
	
	movement.logic_walk( wolf, delta, 0.0 )
	if ( wolf.velocity.length_squared() > 0.0 ):
		
		wolf.move_and_slide()
	
	if ( not wolf.is_on_floor() ):
		
		request_state( StateWolfAir.STATE_NAME )


func _on_wait_timer_timeout() -> void:
	
	request_state( StateWolfMarch.STATE_NAME )
