@tool
extends CharacterBody2D
class_name Entity
## Base scene for all entities, like the player
##
## ditto


signal enabled
signal disabled


## data used for movement
@export var movement_stats: MovementData :
	set( new_movement ):
		update_configuration_warnings.call_deferred()
		
		movement_stats = new_movement

@export var model: DragonModel2D
@export var health_node: NodeHealth
@export var hitbox: Hitbox2D

@export var state_machine: StateMachine

@export var bomb_thrower: BombThrower


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
	
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )
	
	if ( health_node ):
		
		health_node.pre_hurt.connect( _on_node_health_pre_hurt )
		health_node.hurt.connect( _on_node_health_hurt )
		health_node.pre_healed.connect( _on_node_health_pre_healed )
		health_node.healed.connect( _on_node_health_healed )
		health_node.died.connect( _on_node_health_died )


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


## capsule for the full air routine.
## gravity, terminal velocity, and strafing
func routine_airborne( delta: float, direction: Vector2 ) -> void:
	
	logic_air_strafe( delta, direction.x )
	logic_gravity( delta, direction.y )
	logic_terminal_velocity( delta )

#endregion


func logic_wind( delta: float, force: Vector2 ) -> void:
	
	velocity += force * delta


func out_of_bounds() -> void:
	
	queue_free()


func enable() -> void:
	
	_enable()
	enabled.emit()

func disable() -> void:
	
	_disable()
	disabled.emit()

## virtual
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED


func _on_node_health_pre_hurt( damage: Damage ) -> void:
	
	model.flash_color( damage.to_color(), damage.amount / 5.0 )
	_pre_hurt( damage )

func _on_node_health_hurt( damage: Damage ) -> void:
	
	_hurt( damage )

func _on_node_health_pre_healed( heal: Heal ) -> void:
	
	model.flash_color( heal.to_color(), heal.amount / 1.25 )
	_pre_healed( heal )

func _on_node_health_healed( heal: Heal ) -> void:
	
	_healed( heal )

func _on_node_health_died() -> void:
	
	_death()


## virtual
func _pre_hurt( _damage: Damage ) -> void:
	pass

## virtual
func _hurt( _damage: Damage ) -> void:
	pass

## virtual
func _pre_healed( _heal: Heal ) -> void:
	pass

## virtual
func _healed( _heal: Heal ) -> void:
	pass

## virtual
func _death() -> void:
	
	queue_free()


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_settings_update( recived_data )

func _settings_update( _recived_data: SettingsFile ) -> void:
	pass


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is StateMachine and not state_machine ):
		
		state_machine = node
	elif ( node is DragonModel2D and not model ):
		
		model = node
	elif ( node is NodeHealth and not health_node ):
		
		health_node = node
	elif ( node is Hitbox2D and not hitbox ):
		
		hitbox = node
	elif( node is BombThrower and not bomb_thrower ):
		
		bomb_thrower = node
