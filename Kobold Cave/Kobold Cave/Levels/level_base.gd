@tool
extends Node2D
class_name Level
## The area where a game loop takes place
## 
## ditto


## where to respawn the player
@export var respawn_point: Marker2D
## the floor used to play footsteps
@export var tilemap_floor: TileMapLayer: 
	set( new ):
		
		tilemap_floor = new
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not tilemap_floor ):
		
		const text := "Unique footstep sounds won't play without a floor!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.room_pause.connect( pause, CONNECT_DEFERRED )
	KoboldRadio.room_unpause.connect( unpause, CONNECT_DEFERRED )
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )
	KoboldRadio.player_hitstun.connect( _on_radio_player_hitstun, CONNECT_DEFERRED )
	KoboldRadio.player_reset_needed.connect( _on_radio_player_needs_reset )
	KoboldRadio.level_set_spawn.connect( _on_radio_new_spawn )
	
	KoboldRadio.play_footstep.connect( _on_radio_play_footstep )
	
	MainCamera2D.set_follow_coord( get_spawn_position() )
	KoboldUtility.set_camera_zoom_tween( Vector2.ONE, 0.25 )
	
	if ( KoboldUtility.in_level_trans ):
		
		pause.call_deferred()


func pause() -> void:
	
	process_mode = PROCESS_MODE_DISABLED

func unpause() -> void:
	
	process_mode = PROCESS_MODE_INHERIT


func get_spawn_position() -> Vector2:
	
	if ( respawn_point ):
		
		return respawn_point.global_position
	
	return Vector2.ZERO


func _on_radio_goal_touched() -> void:
	
	pause()
	DragonPauser.is_togglable = false

func _on_radio_player_hitstun( damage: Damage ) -> void:
	
	pause()
	await get_tree().create_timer( damage.amount / 5.0, false, false , true ).timeout
	unpause()

func _on_radio_player_needs_reset( player: Player ) -> void:
	
	player.reset_physics_interpolation()
	player.velocity = Vector2.ZERO
	player.global_position = get_spawn_position()
	
	#player.force_update_transform()

func _on_radio_new_spawn( new_spawn: Marker2D ) -> void:
	
	respawn_point = new_spawn

func _on_radio_play_footstep( footstep_pos: Vector2 ) -> void:
	const default_sound: AudioStream = preload( "uid://0grxdom76h0q" )
	
	var sound: AudioStream = default_sound
	
	if ( tilemap_floor ):
		
		var coords: Vector2i = tilemap_floor.local_to_map( tilemap_floor.to_local( footstep_pos ) )
		var data: TileData = tilemap_floor.get_cell_tile_data( coords )
		
		if ( not data ): return
		
		const data_floor_sound := "Footstep"
		if ( data.has_custom_data( data_floor_sound ) ):
			
			sound = data.get_custom_data( data_floor_sound )
	
	DragonSound.in_world.play_sound_2d( sound, footstep_pos )
