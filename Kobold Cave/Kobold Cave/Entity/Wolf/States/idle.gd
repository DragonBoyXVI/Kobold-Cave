
extends StateBehaviour
class_name StateWolfIdle

const STATE_NAME := &"Idle"


@export var wolf: Wolf
@export var movement: MovementGround
@export var wait_timer: Timer


var flip_on_leave: bool = false


func _ready() -> void:
	super()
	
	wait_timer.timeout.connect( _on_wait_timer_timeout )

func _enter( args: Dictionary ) -> void:
	
	const arg_flip := &"Flip on Leave"
	flip_on_leave = args[ arg_flip ]
	
	wait_timer.start()

func _physics_process( delta: float ) -> void:
	
	movement.logic_walk( wolf, delta, 0.0 )
	if ( wolf.velocity.length_squared() > 0.0 ):
		
		wolf.move_and_slide()
	
	if ( not wolf.is_on_floor() ):
		
		request_state( StateWolfAir.STATE_NAME )


func _on_wait_timer_timeout() -> void:
	
	if ( flip_on_leave ):
		
		wolf.set_facing( not wolf.facing_right )
		flip_on_leave = false
	
	request_state( StateWolfMarch.STATE_NAME )
