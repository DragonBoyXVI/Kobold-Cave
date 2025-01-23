@tool
extends KCResource
class_name MovementData


@export_group( "Grounded", "ground_" )
## Max movement speed. pix/s
@export var ground_speed: float = 1200.0
## how quickly you speed up. pix/s
@export var ground_accel: float = 5000.0
## how quickly you slow down. pix/s
@export var ground_decel: float = 5500.0
## the upward force to apply when you jump
@export var ground_jump: float = 1200.0


@export_group( "Aerial", "air_" )
## how much you get gravitied lmao nerd
@export var air_gravity: float = 800.0

## when you're above max speed, get pulled by friction
@export var air_terminal_velocity: float = 2000.0 : 
	set( value ):
		
		air_terminal_velocity = value
		air_terminal_squared = pow( value, 2.0 )
## MATH
@export_storage var air_terminal_squared: float = pow( 2000.0, 2 )
## how much to get pulled when above max speed
@export var air_friction: float = 1000.0

@export_subgroup( "Strafe", "air_move_" )
## max strafe speed
@export var air_move_speed: float = 800.0
## how quickly you can change your air speed
@export var air_move_control_speed: float = 1600.0
