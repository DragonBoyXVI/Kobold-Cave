@tool
extends Entity
class_name ExplodingGhost


func logic_fly_to_point( delta: float, target_position: Vector2 ) -> void:
	
	var target_angle: float
	if ( is_on_ceiling() ):
		
		target_angle = KCResource.ANGLE_DOWN
	elif ( is_on_wall() ):
		
		target_angle = KCResource.ANGLE_UP
	else:
		
		target_angle = position.angle_to_point( target_position )
	
	var target_velocity: Vector2 = Vector2.from_angle( target_angle ) * movement_stats.air_move_speed
	var move_delta: float = movement_stats.air_move_control_speed * delta
	velocity = velocity.move_toward( target_velocity, move_delta )


func logic_fly_in_direction( _delta: float, _direction: Vector2 ) -> void:
	pass


func _death() -> void:
	
	const bombs_to_throw: int = 4
	const circle_degrees: float = deg_to_rad( 360.0 )
	
	for index: int in bombs_to_throw:
		
		var throw_angle: float = ( index / float( bombs_to_throw ) ) * circle_degrees
		bomb_thrower.throw_bomb( Vector2.from_angle( throw_angle ) )
	
	queue_free()


func _on_life_timer_timeout() -> void:
	
	var damage := Damage.new( 555 )
	health_node.recive_event( damage )
