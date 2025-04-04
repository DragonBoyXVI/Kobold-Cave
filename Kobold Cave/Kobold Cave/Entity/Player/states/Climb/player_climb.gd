@tool
extends PlayerState
class_name PlayerClimb

const STATE_NAME := &"PlayerClimb"
const TILE_SIZE := Vector2( 128.0, 128.0 )

@export var climb_finder: ClimbableFinder
@export var ref_node: Marker2D


var climb_speed: float


func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	#climb_speed = movement_stats.ground_speed / 2.0

func _enter( _args: Dictionary ) -> void:
	
	var my_tile: Vector2i = climb_finder.ref_to_tile( ref_node )
	var target_tile: Vector2i = climb_finder.current_tile_coords
	
	# should be -1 to 1
	var direction: int = target_tile.x - my_tile.x
	model.scale.x = direction
	
	player.velocity = Vector2.ZERO
	# grossest way to do it but sure ig
	player.move_and_collide( Vector2( 500.0 * direction, 0.0 ) )
	
	camera_focal.position = CAMERA_FOCAL_OFFSET
	#camera_focal.global_position = TILE_SIZE * Vector2( target_tile )
	#camera_focal.position += TILE_SIZE / 2.0

func _physics_process( delta: float ) -> void:
	
	if ( player.velocity.length_squared() > 0 ):
		
		request_state( PlayerAir.STATE_NAME )
		return
	
	var climb_direction: float = Input.get_axis( &"Move Up", &"Move Down" )
	var climb_speed: float = delta * climb_speed * climb_direction
	player.move_and_collide( Vector2( 0.0, climb_speed ) )
	
	if ( not climb_finder.is_current_tile_climbale() ):
		
		request_state( PlayerAir.STATE_NAME )
		return
