@tool
extends Area2D
class_name LedgeGrabDetector
## emits a signal when a grabbable ledge is detected
## 
## Meth
## NOTE: Monitorable must be on for this to work


const DEBUG_COLOR := Color( "YELLOW", 0.5 )

const DATA_GRAB_PASS := "Grab Pass"

signal found_grab_ledge( grab_info: LedgeGrabInfo )


## your position
@export var position_ref: Marker2D:
	set( new ):
		
		position_ref = new
		update_configuration_warnings()
## where the ray target is for floor checking
@export var floor_ref: Marker2D:
	set( new ):
		
		floor_ref = new
		update_configuration_warnings()
## where the ray target is for ceiling checking
@export var ceiling_ref: Marker2D:
	set( new ):
		
		ceiling_ref = new
		update_configuration_warnings()
## The y position is used to peek over walls
@export var peek_height_ref: Marker2D:
	set( new ):
		
		peek_height_ref = new
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not position_ref ):
		
		const text := "Needs a position ref to source raycast start"
		warnings.append( text )
	
	if ( not floor_ref ):
		
		const text := "Needs a floor ref to see floors"
		warnings.append( text )
	
	if ( not ceiling_ref ):
		
		const text := "Needs a ceiling ref to see ceilings"
		warnings.append( text )
	
	if ( not peek_height_ref ):
		
		const text := "Cant peek over edges without a peek ref"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered_tree )
		return


func enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT
	show()

func disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED
	hide()


func emit_grabbed( grab_info: LedgeGrabInfo ) -> void:
	
	found_grab_ledge.emit( grab_info )


func _on_body_shape_entered( body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int ) -> void:
	var grab_info := LedgeGrabInfo.new()
	
	# get grab pos and side
	if ( body is TileMapLayer ):
		var tile_map: TileMapLayer = ( body as TileMapLayer )
		
		var found_coords: Vector2i = tile_map.get_coords_for_body_rid( body_rid )
		grab_info.grab_position = tile_map.to_global( tile_map.map_to_local( found_coords ) )
		grab_info.grab_to_the_right = ( grab_info.grab_position.x > position_ref.global_position.x )
		
		var tile_size: Vector2 = tile_map.tile_set.tile_size
		const game_tiles: TileSet = preload( "uid://b8dql8ixu6yvr" )
		if ( tile_map.tile_set == game_tiles ):
			
			tile_size *= 0.8
		if ( grab_info.grab_to_the_right ):
			
			grab_info.grab_position += tile_size * Vector2( -0.5, -0.5 )
		else:
			
			grab_info.grab_position += tile_size * Vector2( 0.5, -0.5 )
	
	if ( body is CollisionObject2D ):
		var col_body: CollisionObject2D = ( body as CollisionObject2D )
		
		# get relivant nodes
		var body_shape_owner: int = col_body.shape_find_owner( body_shape_index )
		var body_shape_node: CollisionShape2D = col_body.shape_owner_get_owner( body_shape_owner )
		
		# where we grab it
		var body_shape_rect: Rect2 = body_shape_node.shape.get_rect()
		grab_info.grab_to_the_right = ( body_shape_node.global_position.x > global_position.x )
		if ( grab_info.grab_to_the_right ):
			
			grab_info.grab_position = body_shape_node.global_position + body_shape_rect.position
		else:
			
			grab_info.grab_position = body_shape_node.global_position + ( body_shape_rect.position + Vector2( body_shape_rect.size.x, 0.0 ) )
	
	# distance check
	const grab_dist_max := pow( 128.0, 2 )
	if ( position_ref.global_position.distance_squared_to( grab_info.grab_position ) > grab_dist_max ):
		return
	
	# check below and above you
	var direct_state := get_world_2d().direct_space_state
	
	var ray_query := PhysicsRayQueryParameters2D.new()
	ray_query.hit_from_inside = true
	ray_query.from = position_ref.global_position
	ray_query.collision_mask = 0b1
	
	ray_query.to = floor_ref.global_position
	var result: Dictionary = direct_state.intersect_ray( ray_query )
	if ( not result.is_empty() ):
		return
	ray_query.to = ceiling_ref.global_position
	result = direct_state.intersect_ray( ray_query )
	if ( not result.is_empty() ):
		return
	
	# peek over
	const peek_length := Vector2( 48.0, 0 )
	ray_query.from = grab_info.grab_position + Vector2.UP
	ray_query.to = ray_query.from + ( peek_length * ( 1.0 if grab_info.grab_to_the_right else -1.0 ) )
	result = direct_state.intersect_ray( ray_query )
	if ( not result.is_empty() ):
		return
	
	emit_grabbed( grab_info )


var _querr: PhysicsRayQueryParameters2D
func _draw() -> void:
	
	if ( _querr ):
		
		var from := to_local( _querr.from )
		var to := to_local( _querr.to )
		draw_line( from, to, Color.RED, 5.0 )


func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = DEBUG_COLOR
