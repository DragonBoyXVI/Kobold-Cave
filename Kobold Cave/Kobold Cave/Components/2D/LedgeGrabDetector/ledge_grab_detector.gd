@tool
extends Area2D
class_name LedgeGrabDetector
## emits a signal when a grabbable ledge is detected
## 
## Meth
## NOTE: Monitorable must be on for this to work


const DEBUG_COLOR := Color( "YELLOW", 0.5 )

const DATA_GRAB_PASS := "Grab Pass"

signal found_grab_ledge( grab_position: Vector2, right_side: bool )


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
		
		if ( tile_data.get_custom_data( DATA_GRAB_PASS ) ):
			
			return false
		else:
			
			return true
	
	return false


func _on_body_shape_entered( body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int ) -> void:
	
	
	return
	@warning_ignore("unreachable_code")
	
	var ledge_info := LedgeGrabInfo.new()
	
	if ( body is CollisionObject2D ):
		
		# THANK YOU DOCS MSMNSMMM
		var col_body := body as CollisionObject2D
		var body_shape_owner: int = col_body.shape_find_owner( body_shape_index )
		var body_shape_node := col_body.shape_owner_get_owner( body_shape_owner ) as CollisionShape2D
		var body_shape_rect: Rect2 = body_shape_node.shape.get_rect()
		
		print( body_shape_rect )
		
		# i dont think i need this since the game will be mostly tiles...
	elif ( body is TileMapLayer ):
		
		var tile_body := body as TileMapLayer
		
		var body_shape_rid: RID = PhysicsServer2D.body_get_shape( body_rid, body_shape_index )
		var tile_coords: Vector2i = tile_body.get_coords_for_body_rid( body_shape_rid )
		var top_tile_coords: Vector2i = tile_body.get_neighbor_cell( tile_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE )
		
		print( tile_body.has_body_rid( body_shape_rid ) )
		
		# no uppies if tile on top
		if ( tile_body.get_cell_tile_data( top_tile_coords ) ): 
			return
		
		var coords: Vector2 = tile_body.to_global( tile_body.map_to_local( tile_coords ) )
		var size: Vector2 = tile_body.tile_set.tile_size
		
		if ( global_position.x > coords.x ):
			
			ledge_info.grab_to_the_right = true
			ledge_info.grab_position = coords + ( size * Vector2( 1.0, -1.0 ) )
		else:
			
			ledge_info.grab_to_the_right = false
			ledge_info.grab_position = coords + ( size * Vector2( -1.0, -1.0 ) )
	
	
	
	found_grab_ledge.emit( ledge_info )


func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = DEBUG_COLOR


func _on_body_entered( body: Node2D ) -> void:
	
	if ( body is TileMapLayer ):
		
		var tile_body := body as TileMapLayer
		var my_tile_position: Vector2i = tile_body.local_to_map( tile_body.to_local( tile_ref.global_position ) )
		
		
		if ( tile_blocks_grab( tile_body, my_tile_position + Vector2i.UP ) ):
			return
		if ( tile_blocks_grab( tile_body, my_tile_position + Vector2i.DOWN ) ):
			return
		
		var left_tile: Vector2i = my_tile_position + Vector2i( -1, 0 )
		var right_tile: Vector2i = my_tile_position + Vector2i( 1, 0 )
		
		var grabbed_tile: Vector2i
		var grabbed_right_side: bool
		if ( tile_body.get_cell_tile_data( left_tile ) ):
			
			grabbed_tile = left_tile
			grabbed_right_side = false
		elif( tile_body.get_cell_tile_data( right_tile ) ):
			
			grabbed_tile = right_tile
			grabbed_right_side = true
		
		if ( grabbed_tile ):
			
			if ( tile_blocks_grab( tile_body, grabbed_tile + Vector2i.UP ) ):
				return
			
			var grab_position: Vector2 = tile_body.to_global( tile_body.map_to_local( grabbed_tile ) )
			found_grab_ledge.emit( grab_position, grabbed_right_side )
