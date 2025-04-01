@tool
extends Movement
class_name MovementGround
## Component for ground movement
##
## ditto


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


func _init() -> void:
	super()
	
	name = "MovementGround"


## walk to the left or right
func logic_walk( body: CharacterBody2D, delta: float, direction: float ) -> void:
	
	var velocity_dir: float = signf( body.velocity.x )
	var direction_dir: float = signf( direction )
	if ( is_zero_approx( body.velocity.x ) ):
		
		velocity_dir = direction_dir
	
	
	var speed_target: float = ground_speed * direction
	var speed_delta: float = delta
	if ( direction_dir == velocity_dir ):
		
		speed_delta *= ground_accel
	else:
		
		speed_delta *= ground_decel
	
	body.velocity.x = move_toward( body.velocity.x, speed_target, speed_delta )

## apply an upward force
func logic_apply_jump( body: CharacterBody2D, strength: float = 1.0 ) -> void:
	
	body.velocity.y -= ground_jump * strength

## move left and right while airborne
func logic_air_strafe( body: CharacterBody2D, delta: float, direction: float ) -> void:
	
	# wonder if this is gonna fuck me
	if ( is_zero_approx( direction ) ): return
	
	var direction_dir: float = signf( direction )
	var velocity_dir: float = signf( body.velocity.x )
	
	
	var strafe_delta: float = delta * absf( direction ) * air_move_control_speed
	var strafe_target: float = air_move_speed * direction_dir
	
	if ( direction_dir == velocity_dir ):
		if ( absf( body.velocity.x ) > air_move_speed ):
			
			strafe_delta = 0.0
			return
	
	body.velocity.x = move_toward( body.velocity.x, strafe_target, strafe_delta )
