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


func _on_body_shape_entered( body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int ) -> void:
	
	var grab_info := LedgeGrabInfo.new()
	grab_info.grabbed_node = body
	grab_info.my_position = tile_ref.global_position
	
	if ( body is TileMapLayer ):
		var tile_map: TileMapLayer = ( body as TileMapLayer )
		
		var found_coords: Vector2i = tile_map.get_coords_for_body_rid( body_rid )
		var my_coords: Vector2i = ( tile_map.local_to_map( tile_map.to_local( tile_ref.global_position ) ) )
		
		# something above/below me?
		if ( tile_blocks_grab( tile_map, my_coords + Vector2i.UP ) ):
			return
		if ( tile_blocks_grab( tile_map, my_coords + Vector2i.DOWN ) ):
			return
		
		# something above the target tile?
		if ( tile_blocks_grab( tile_map, found_coords + Vector2i.UP ) ):
			return
		
		grab_info.grab_position = tile_map.to_global( tile_map.map_to_local( found_coords ) )
		grab_info.grab_to_the_right = ( ( grab_info.grab_position.x - grab_info.my_position.x ) > 0 )
		
		emit_grabbed( grab_info )


func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = DEBUG_COLOR
