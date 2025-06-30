@tool
extends Entity
class_name Player
## The playr
## 
## yuyg


@export var bomb_thrower: BombThrower


func _input( event: InputEvent ) -> void:
	
	if ( not KoboldUtility.debug_mode ): return
	
	if ( event is InputEventKey and event.is_pressed() ):
		match event.keycode:
			
			KEY_SPACE:
				
				KoboldRadio.player_reset_needed.emit( self )
			
			KEY_P: 
				
				velocity.x += 2_000.0
			
			KEY_O:
				
				velocity.y -= 2_000.0
			
			KEY_0:
				
				damage_profile.take_heal( Heal.new( 1 ) )
			
			KEY_9:
				
				damage_profile.take_heal( Heal.new( 5 ) )
			
			KEY_8:
				
				damage_profile.health.set_percent( 1.0 )
			
			KEY_7:
				
				KoboldRadio.goal_touched.emit()
			
			KEY_6:
				
				bomb_thrower.refill()
			
			KEY_5:
				
				velocity = Vector2.ZERO
				global_position = get_global_mouse_position()
			
			KEY_4:
				
				if ( event.is_echo() ): return
				set_process_input( false )
				get_tree().reload_current_scene.call_deferred()
			
			KEY_1:
				
				Engine.time_scale = 0.05
			
			KEY_2:
				
				Engine.time_scale = 1.0
			
			KEY_3:
				
				Engine.time_scale = 0.0
			
			KEY_F1:
				
				print( "orphans: " )
				print_orphan_nodes()
			
			KEY_F2:
				
				var params := ExplosionParameters.new()
				params.position = get_global_mouse_position()
				ExplosionServer.create_explosion( params )
			
			KEY_F3:
				
				const TIMES: int = 25
				for _i in TIMES:
					
					var params := ExplosionParameters.new()
					ExplosionServer.create_explosion( params )
			
			KEY_F4:
				
				var params := ExplosionParameters.new()
				params.damage = Damage.new( -55555 )
				params.position = get_global_mouse_position()
				ExplosionServer.create_explosion( params )
			
			KEY_F5:
				
				const BOMB: PackedScene = preload( "res://Kobold Cave/Bomb/bomb.tscn" )
				var bomb: Node2D = BOMB.instantiate()
				bomb.position = get_global_mouse_position()
				
				get_tree().current_scene.add_child.call_deferred( bomb )

func _exit_tree() -> void:
	
	Engine.time_scale = 1.0

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	damage_profile.health.set_percent( 1.0 )
	damage_profile.pre_damage.connect( _on_pre_hurt )
	
	KoboldRadio.ui_connect_health.emit( damage_profile.health )
	KoboldRadio.ui_connect_bombs.emit( bomb_thrower )

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_UNPAUSED:
			
			if ( StopWatch.is_started ):
				
				StopWatch.unpause()
			else:
				
				StopWatch.start()
		
		NOTIFICATION_PAUSED:
			
			StopWatch.pause()


func out_of_bounds() -> void:
	
	KoboldRadio.player_reset_needed.emit( self )
	# the wolrd pausing causes this to happen twice
	await get_tree().create_timer( 0.25 ).timeout
	damage_profile.take_damage( Damage.new( 1, 55555 ) )


var _was_hurt_this_frame: bool = false
func _on_pre_hurt( damage: Damage ) -> void:
	
	if ( _was_hurt_this_frame ):
		
		damage.amount = -55555
	else:
		
		_was_hurt_this_frame = true
		set_deferred( &"_was_hurt_this_frame", false )
		return

func _on_hurt( damage: Damage ) -> void:
	super( damage )
	
	if ( damage_profile.health.current > 0 ):
		
		state_machine.change_state( PlayerHitStun.STATE_NAME )
	
	var cam_effect := CameraShake2D.new()
	cam_effect.duration_max = 0.25
	cam_effect.shake_strength = 25.0 * damage.amount
	
	MainCamera2D.add_effect( cam_effect )
	
	KoboldRadio.player_hitstun.emit( damage )

func _on_died() -> void:
	
	KoboldRadio.player_died.emit()
	# enter a dead state here ig
	state_machine.change_state( PlayerDead.STATE_NAME )
	
	# simulate reciving the dead signal
	var input := InputEventAction.new()
	input.action = &"Pause"
	input.pressed = true
	Input.parse_input_event( input )
	
	model.scale.y = 0.1


func _on_tree_paused( paused: bool ) -> void:
	
	if ( not paused ): return
	
	modulate.a = maxf( 0.5, modulate.a )
	show()
