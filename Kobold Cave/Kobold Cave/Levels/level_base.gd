
extends Node2D
class_name Level
## The area where a game loop takes place
## 
## ditto


## where to respawn the player
var respawn_point: Marker2D


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )
	KoboldRadio.level_clear_next_pressed.connect( get_tree().quit, CONNECT_DEFERRED )
	KoboldRadio.player_hitstun.connect( _on_radio_player_hitstun, CONNECT_DEFERRED )
	KoboldRadio.player_reset_needed.connect( _on_radio_player_needs_reset )

func _input( event: InputEvent ) -> void:
	
	if ( event is InputEventKey and event.is_pressed() ):
		
		match event.keycode:
			
			KEY_1:
				
				Engine.time_scale = 0.05
			
			KEY_2:
				
				Engine.time_scale = 1.0
			
			KEY_3:
				
				pause()
				await get_tree().create_timer( 5.0 ).timeout
				unpause()


func pause() -> void:
	
	process_mode = PROCESS_MODE_DISABLED

func unpause() -> void:
	
	process_mode = PROCESS_MODE_INHERIT


func _test() -> void:
	
	#propagate_notification()
	
	pass


func _on_radio_goal_touched() -> void:
	
	pause()

func _on_radio_player_hitstun( damage: BaseDamage ) -> void:
	
	pause()
	await get_tree().create_timer( damage.amount / 5.0 ).timeout
	unpause()

func _on_radio_player_needs_reset( player: Player ) -> void:
	
	player.reset_physics_interpolation()
	player.velocity = Vector2.ZERO
	if ( respawn_point ):
		
		player.global_position = respawn_point.global_position
	else:
		
		player.global_position = Vector2.ZERO
	
	#player.force_update_transform()
