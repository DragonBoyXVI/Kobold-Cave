@tool
extends Entity
class_name Player
## The playr
## 
## yuyg


@export var bomb_thrower: BombThrower
@export var hitbox: Hitbox2D
@export var state_machine: StateMachine


var _flashing_lights: bool


func _input( event: InputEvent ) -> void:
	
	if ( event is InputEventKey and event.is_pressed() ):
		match event.keycode:
			
			KEY_SPACE:
				
				KoboldRadio.player_reset_needed.emit( self )
			
			KEY_P: 
				
				velocity.x += 2_000.0
			
			KEY_O:
				
				velocity.y -= 2_000.0
			
			KEY_0:
				
				health_node.recive_event( Heal.new( 1 ) )
			
			KEY_9:
				
				health_node.recive_event( Heal.new( 5 ) )
			
			KEY_8:
				
				health_node.health.current = 5
			
			KEY_7:
				
				KoboldRadio.goal_touched.emit()
			
			KEY_6:
				
				bomb_thrower.refill()
			
			KEY_1:
				
				Engine.time_scale = 0.05
			
			KEY_2:
				
				Engine.time_scale = 1.0
			
			KEY_F1:
				
				print( "orphans: " )
				print_orphan_nodes()

func _exit_tree() -> void:
	
	Engine.time_scale = 1.0

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	DragonControler.tree_paused.connect( _on_tree_paused, CONNECT_DEFERRED )
	
	KoboldRadio.ui_connect_health.emit( health_node.health )
	KoboldRadio.ui_connect_bombs.emit( bomb_thrower )
	
	state_machine.state_entered.connect( func( state: StateBehaviour ) -> void:
		print( state.name )
		pass )


var _i_frame_tween: Tween
@export var _i_frame_timer: Timer
func start_i_frames() -> void:
	
	hitbox.disable.call_deferred()
	_i_frame_timer.start()
	
	if ( _i_frame_tween ):
		
		_i_frame_tween.kill()
	
	var tween := create_tween()
	tween.set_loops(  )
	tween.set_ignore_time_scale()
	
	if ( _flashing_lights ):
		
		tween.tween_callback( hide ).set_delay( 0.125 )
		tween.tween_callback( show ).set_delay( 0.125 )
	else:
		
		tween.tween_property( self, ^"modulate", Color.TRANSPARENT, 0.250 )
		tween.tween_property( self, ^"modulate", Color.WHITE, 0.250 )
	
	_i_frame_tween = tween

func end_i_frames() -> void:
	
	if ( _i_frame_tween ):
		
		_i_frame_tween.kill()
		_i_frame_tween = null
	
	hitbox.enable.call_deferred()
	
	show()
	modulate = Color.WHITE


func out_of_bounds() -> void:
	
	KoboldRadio.player_reset_needed.emit( self )
	# the wolrd pausing causes this to happen twice
	#await get_tree().create_timer( 0.5 ).timeout
	
	if ( _i_frame_timer.is_stopped() ):
		
		health_node.recive_event( Damage.new( 1 ) )


func _pre_hurt( damage: Damage ) -> void:
	
	print( damage.to_string() )

func _hurt( damage: Damage ) -> void:
	
	start_i_frames()
	
	var cam_effect := CameraShake2D.new()
	cam_effect.duration_max = 0.25
	cam_effect.shake_strength = 25.0 * damage.amount
	
	MainCamera2D.add_effect( cam_effect )
	
	KoboldRadio.player_hitstun.emit( damage )
	
	print( "took: ", damage.amount, " HP: ", health_node.health.current )

func _death() -> void:
	
	KoboldRadio.player_died.emit()
	# enter a dead state here ig
	state_machine.change_state( PlayerDead.STATE_NAME )
	
	# simulate reciving the dead signal
	var input := InputEventAction.new()
	input.action = &"Pause"
	input.pressed = true
	Input.parse_input_event( input )
	
	model.scale.y = 0.1


func _settings_update( recived_data: SettingsFile ) -> void:
	
	_flashing_lights = recived_data.flashing_lights


func _on_tree_paused( paused: bool ) -> void:
	
	if ( not paused ): return
	
	modulate.a = maxf( 0.5, modulate.a )
	show()


func _on_i_frames_timer_timeout() -> void:
	
	end_i_frames()
