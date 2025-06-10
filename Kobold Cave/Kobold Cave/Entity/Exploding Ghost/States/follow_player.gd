@tool
extends StateBehaviour



@export var ghost: ExplodingGhost
@export var movement: MovementFlying

var player: Player


const explode_dis: float = pow( 64.0, 2 )


func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	const arg_player := &"Player"
	if ( args[ arg_player ] is Player ):
		
		player = args[ arg_player ]
	else:
		
		player = null

func _physics_process( delta: float ) -> void:
	
	if ( not is_instance_valid( player ) ): 
		
		request_state( &"NoAi" )
		return
	
	movement.logic_fly_to_point( ghost, delta, player.global_position )
	ghost.move_and_slide()
	
	if ( ghost.global_position.distance_squared_to( player.global_position ) < explode_dis ):
		
		var damage := Damage.new( 555 )
		ghost.damage_profile.take_damage( damage )


func _on_area_see_player_body_exited( body: Node2D ) -> void:
	
	if ( not is_inside_tree() ): return
	if ( not can_process() ): return
	if ( body != player ): return
	
	player = null
	request_state( &"NoAi" )
