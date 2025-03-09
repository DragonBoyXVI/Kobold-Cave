
extends Node2D
class_name Level
## The area where a game loop takes place
## 
## ditto


## where to respawn the player
@export var respawn_point: Marker2D


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.room_pause.connect( pause, CONNECT_DEFERRED )
	KoboldRadio.room_unpause.connect( unpause, CONNECT_DEFERRED )
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )
	KoboldRadio.player_hitstun.connect( _on_radio_player_hitstun, CONNECT_DEFERRED )
	KoboldRadio.player_reset_needed.connect( _on_radio_player_needs_reset )
	KoboldRadio.level_set_spawn.connect( _on_radio_new_spawn )
	
	MainCamera2D.set_follow_coord( get_spawn_position() )
	MainCamera2D.set_zoom_tween( Vector2.ONE, 0.25 )
	
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

func _on_radio_player_hitstun( damage: Damage ) -> void:
	
	pause()
	await get_tree().create_timer( damage.amount / 5.0 ).timeout
	unpause()

func _on_radio_player_needs_reset( player: Player ) -> void:
	
	player.reset_physics_interpolation()
	player.velocity = Vector2.ZERO
	player.global_position = get_spawn_position()
	
	#player.force_update_transform()

func _on_radio_new_spawn( new_spawn: Marker2D ) -> void:
	
	respawn_point = new_spawn
	print( "new spawn: ", new_spawn.global_position )
