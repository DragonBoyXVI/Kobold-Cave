extends KCResource
class_name MovementFlying


@export_group( "Fly", "flying_" )
## how fast this can move
@export var flying_speed: float = 1200.0
## how quickly this ramps up to full speed
@export var flying_accel: float = 5000.0


## fly toward a position
func logic_fly_to_point( body: CharacterBody2D, delta: float, target_position: Vector2 ) -> void:
	
	var target_angle: float
	if ( body.is_on_ceiling() ):
		
		target_angle = ANGLE_DOWN
	elif ( body.is_on_wall() ):
		
		target_angle = ANGLE_UP
	else:
		
		target_angle = body.position.angle_to_point( target_position )
	
	var target_velocity: Vector2 = Vector2.from_angle( target_angle ) * flying_speed
	var move_delta: float = flying_accel * delta
	body.velocity = body.velocity.move_toward( target_velocity, move_delta )

## stop flying and stand still
func logic_fly_in_place( body: CharacterBody2D, delta: float ) -> void:
	
	var speed_delta: float = flying_accel * delta
	body.velocity = body.velocity.move_toward( Vector2.ZERO, speed_delta )
