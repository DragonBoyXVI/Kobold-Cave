@tool
extends CharacterBody2D
class_name Entity
## Base scene for all entities, like the player
##
## ditto


## data used for movement
@export var movement_stats: MovementData :
	set( new_movement ):
		update_configuration_warnings.call_deferred()
		
		movement_stats = new_movement


@export var state_machine: StateMachine


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not movement_stats ):
		
		const text := "Please provide movement data to use!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return


#region ground routines


## logic for walking left and right [br]
## handles accelerating and decelerating
func logic_walk( delta: float, direction: float ) -> void:
	
	var velocity_dir: float = signf( velocity.x )
	var direction_dir: float = signf( direction )
	if ( is_zero_approx( velocity.x ) ):
		
		velocity_dir = direction_dir
	
	
	var speed_target: float = movement_stats.ground_speed * direction
	var speed_delta: float = delta
	if ( direction_dir == velocity_dir ):
		
		speed_delta *= movement_stats.ground_accel
	else:
		
		speed_delta *= movement_stats.ground_decel
	
	velocity.x = move_toward( velocity.x, speed_target, speed_delta )


func logic_apply_jump( strength: float = 1.0 ) -> void:
	
	velocity.y -= movement_stats.ground_jump * strength


#endregion

#region air routines


## logic for strafing while falling
func logic_air_strafe( delta: float, direction: float ) -> void:
	
	# wonder if this is gonna fuck me
	if ( is_zero_approx( direction ) ): return
	
	var direction_dir: float = signf( direction )
	var velocity_dir: float = signf( velocity.x )
	
	
	var strafe_delta: float = delta * absf( direction ) * movement_stats.air_move_control_speed
	var strafe_target: float = movement_stats.air_move_speed * direction_dir
	
	if ( direction_dir == velocity_dir ):
		if ( absf( velocity.x ) > movement_stats.air_move_speed ):
			
			strafe_delta = 0.0
			return
	
	velocity.x = move_toward( velocity.x, strafe_target, strafe_delta )

## logic for gravity, use direction to fall faster/slower
func logic_gravity( delta: float, direction: float = 0.0 ) -> void:
	
	direction = remap( direction, -1.0, 1.0, 0.5, 1.5 )
	velocity.y += delta * movement_stats.air_gravity * direction

## logic for air drag
func logic_terminal_velocity( delta: float ) -> void:
	
	if ( velocity.length_squared() > movement_stats.air_terminal_squared ):
		
		var velocity_target: Vector2 = movement_stats.air_terminal_velocity * velocity.normalized()
		var velocity_delta: float = delta * movement_stats.air_friction
		velocity = velocity.move_toward( velocity_target, velocity_delta )

#endregion


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is StateMachine and not state_machine ):
		
		state_machine = node
