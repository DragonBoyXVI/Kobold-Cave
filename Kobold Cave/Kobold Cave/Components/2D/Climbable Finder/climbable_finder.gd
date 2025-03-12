
extends Area2D
class_name ClimbableFinder
## an area that tracks climbable tiles in its reach.
##
## The area tracks tiles that enter it, if that tile
## is climbable, track it and check it until climbing 
## becomes a valid action


## use this to ref what our tile position is
## tilemap coords_to_tile or whatever
@export var position_marker: Marker2D


var current_map: TileMapLayer
var current_tile_coords: Vector2i
var current_data: TileData

const CLIMB_NAME := "Can Climb"


func ref_to_tile( ref_node: Marker2D ) -> Vector2i:
	
	if ( not current_map ): return Vector2i.ZERO
	
	return current_map.local_to_map( current_map.to_local( ref_node.global_position ) )


func is_current_tile_climbale() -> bool:
	
	if ( not current_map ): return false
	
	return tile_is_climbable( current_map, current_tile_coords, current_data )

func tile_is_climbable( map: TileMapLayer, coords: Vector2i, data: TileData ) -> bool:
	
	const square_distance_limit: int = 1
	# too far away
	var my_coords: Vector2i = map.local_to_map( map.to_local( position_marker.global_position ) )
	if ( my_coords.distance_squared_to( coords ) > square_distance_limit ): return false
	
	
	if ( data.has_custom_data( CLIMB_NAME ) ):
		if ( data.get_custom_data( CLIMB_NAME ) ):
			return true
	
	# no grab if tile above
	if ( map.get_cell_tile_data( coords + Vector2i.UP ) ): return false
	
	# no grab if tile above or below you
	if ( map.get_cell_tile_data( my_coords + Vector2i.UP ) ): return false
	if ( map.get_cell_tile_data( my_coords + Vector2i.DOWN ) ): return false
	
	return true


func _on_body_shape_entered( body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int ) -> void:
	
	if ( body is not TileMapLayer ): return
	var body_map := body as TileMapLayer
	
	var found_coords: Vector2i = body_map.get_coords_for_body_rid( body_rid )
	var found_data: TileData = body_map.get_cell_tile_data( found_coords )
	
	if ( tile_is_climbable( body_map, found_coords, found_data ) ):
		
		current_map = body_map
		current_tile_coords = found_coords
		current_data = found_data
	
	pass

func _on_body_shape_exited( body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int ) -> void:
	
	if ( body is not TileMapLayer ): return
	var body_map := body as TileMapLayer
	
	var found_coords: Vector2i = body_map.get_coords_for_body_rid( body_rid )
	if ( current_tile_coords == found_coords ):
		
		current_map = null
