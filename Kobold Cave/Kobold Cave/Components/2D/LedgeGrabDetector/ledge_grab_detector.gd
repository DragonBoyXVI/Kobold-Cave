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


@export var tile_ref: Marker2D


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


func tile_blocks_grab( tile_body: TileMapLayer, coords: Vector2i ) -> bool:
	
	var tile_data: TileData = tile_body.get_cell_tile_data( coords )
	
	if ( tile_data ):
		
		if ( tile_data.has_custom_data( DATA_GRAB_PASS ) ):
			
			if ( tile_data.get_custom_data( DATA_GRAB_PASS ) ):
				
				return false
			else:
				
				return true
		else:
			
			return true
	
	return false

func emit_grabbed( grab_info: LedgeGrabInfo ) -> void:
	
	found_grab_ledge.emit( grab_info )


func _on_body_shape_entered( body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int ) -> void:
	var grab_info := LedgeGrabInfo.new()
	
	if ( body is TileMapLayer ):
		var tile_map: TileMapLayer = ( body as TileMapLayer )
		
		var found_coords: Vector2i = tile_map.get_coords_for_body_rid( body_rid )
		var my_coords: Vector2i = ( tile_map.local_to_map( tile_map.to_local( tile_ref.global_position ) ) )
		
		# solve inside tile
		if ( found_coords == my_coords ):
			
			var found_position: Vector2 = tile_map.to_global( tile_map.map_to_local( found_coords ) )
			if ( found_position.x > tile_ref.global_position.x ):
				my_coords += Vector2i.LEFT
			else:
				my_coords += Vector2i.RIGHT
		
		
		# something above/below me?
		if ( tile_blocks_grab( tile_map, my_coords + Vector2i.UP ) ):
			return
		if ( tile_blocks_grab( tile_map, my_coords + Vector2i.DOWN ) ):
			return
		
		# something above the target tile?
		if ( tile_blocks_grab( tile_map, found_coords + Vector2i.UP ) ):
			return
		
		grab_info.grab_position = tile_map.to_global( tile_map.map_to_local( found_coords ) )
		grab_info.grab_to_the_right = ( ( found_coords.x - my_coords.x ) > 0 )
		
		emit_grabbed( grab_info )
		return
	
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
		
		# too far away to grab?
		const grab_distance := pow( 64.0, 2.0 )
		if ( global_position.distance_squared_to( grab_info.grab_position ) > grab_distance ):
			return
		
		# something above/below me?
		const VECTOR_UP := Vector2( 0.0, -64.0 )
		const VECTOR_DOWN := Vector2( 0.0, 192.0 )
		var query := PhysicsRayQueryParameters2D.new()
		query.from = global_position
		query.collision_mask = 0b1
		var direct_state := get_world_2d().direct_space_state
		
		query.to = global_position + VECTOR_UP
		var result_cast_up: Dictionary = direct_state.intersect_ray( query )
		if ( not result_cast_up.is_empty() ):
			return
		query.to = global_position + VECTOR_DOWN
		var result_cast_down: Dictionary = direct_state.intersect_ray( query )
		if ( not result_cast_down.is_empty() ):
			return
		
		
		# make sure nothing is above it
		const LEDGE_OFFSET := Vector2( 32, -2.0 ) # x get flipped based on if the wall is to the right
		const LEDGE_UP := Vector2( 0.0, -128.0 )
		
		query.from = grab_info.grab_position
		if ( grab_info.grab_to_the_right ):
			
			query.from += LEDGE_OFFSET
		else:
			
			query.from += ( LEDGE_OFFSET * Vector2( -1.0, 1.0 ) )
		query.to = query.from + LEDGE_UP
		var result_ledge: Dictionary = direct_state.intersect_ray( query )
		if ( not result_ledge.is_empty() ):
			return
		
		grab_info.grab_position.y += 64.0 # magic
		emit_grabbed( grab_info )


func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = DEBUG_COLOR
