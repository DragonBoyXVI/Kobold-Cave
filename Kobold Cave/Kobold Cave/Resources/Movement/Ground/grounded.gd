@tool
@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends Resource
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


## walk to the left or right
func logic_walk( body: CharacterBody2D, delta: float, direction: float ) -> void:
	
	var velocity_dir: float = signf( body.velocity.x )
	var direction_dir: float = signf( direction )
	if ( is_zero_approx( body.velocity.x ) ):
		
		velocity_dir = direction_dir
	
	
	var speed_target: float = ground_speed * direction
	var speed_delta: float = delta
	var accel_type: float = direction_dir * velocity_dir
	if ( accel_type == 1.0 ):
		
		speed_delta *= ground_accel
	elif ( accel_type == -1.0 ):
		
		speed_delta *= ( ground_accel + ground_decel )
	else:
		
		speed_delta *= ground_decel
	
	body.velocity.x = move_toward( body.velocity.x, speed_target, speed_delta )


## apply an upward force
func logic_apply_jump( body: CharacterBody2D, strength: float = 1.0 ) -> void:
	
	body.velocity.y -= ground_jump * strength

func logic_apply_backflip( body: CharacterBody2D, direction: float ) -> void:
	
	logic_apply_jump( body, 1.25 )
	
	body.velocity.x += ground_speed * 0.05 * direction

func logic_apply_longjump( body: CharacterBody2D, direction: float ) -> void:
	
	logic_apply_jump( body, 0.75 )
	
	var power := 2.0
	if ( not body.is_on_floor() ):
		
		power = 1.25
	body.velocity.x += ground_speed * power * direction


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

## logic for gravity, use direction to fall faster/slower
func logic_gravity( body: CharacterBody2D, delta: float, direction: float = 0.0 ) -> void:
	
	direction = remap( direction, -1.0, 1.0, 0.5, 1.5 )
	body.velocity.y += delta * air_gravity * direction

## logic for air drag
func logic_terminal_velocity( body: CharacterBody2D, delta: float ) -> void:
	
	if ( body.velocity.length_squared() > air_terminal_squared ):
		
		var velocity_target: Vector2 = air_terminal_velocity * body.velocity.normalized()
		var velocity_delta: float = delta * air_friction
		body.velocity = body.velocity.move_toward( velocity_target, velocity_delta )

## capsule for the full air routine.
## gravity, terminal velocity, and strafing
func routine_airborne( body: CharacterBody2D, delta: float, direction: Vector2 ) -> void:
	
	logic_air_strafe( body, delta, direction.x )
	logic_gravity( body, delta, direction.y )
	logic_terminal_velocity( body, delta )
