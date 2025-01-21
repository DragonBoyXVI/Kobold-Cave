@tool
extends Area2D
class_name LedgeGrabDetector
## emits a signal when a grabbable ledge is detected
## 
## Meth
## NOTE: Monitorable must be on for this to work


const DEBUG_COLOR := Color( "YELLOW", 0.5 )


signal found_grab_ledge( rect: Rect2 )


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered_tree )
		return


func _on_body_shape_entered( body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int ) -> void:
	
	print( "ran" )
	
	# fidn the shape, get its rect. if it cant br found, no grabbies
	var shape_rect: Rect2
	
	if ( body is CollisionObject2D ):
		
		# THANK YOU DOCS MSMNSMMM
		var col_body := body as CollisionObject2D
		var body_shape_owner: int = col_body.shape_find_owner( body_shape_index )
		var body_shape_node := col_body.shape_owner_get_owner( body_shape_owner ) as CollisionShape2D
		
		shape_rect = body_shape_node.shape.get_rect()
	elif ( body is TileMapLayer ):
		
		var tile_body := body as TileMapLayer
		
		var body_shape_rid: RID = PhysicsServer2D.body_get_shape( body_rid, body_shape_index )
		var tile_coords: Vector2i = tile_body.get_coords_for_body_rid( body_shape_rid )
		var top_tile_coords: Vector2i = tile_body.get_neighbor_cell( tile_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE )
		
		# no tile on top, grab this tile
		if ( not tile_body.get_cell_tile_data( top_tile_coords ) ):
			
			var coords: Vector2 = tile_body.to_global( tile_body.map_to_local( tile_coords ) )
			var size: Vector2 = tile_body.tile_set.tile_size
			shape_rect = Rect2( coords, size )
	
	if ( shape_rect ):
		
		found_grab_ledge.emit( shape_rect )



func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = DEBUG_COLOR
