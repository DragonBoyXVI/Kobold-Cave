@tool
extends Entity
class_name Player
## The playr
## 
## yuyg


func _input( event: InputEvent ) -> void:
	
	if ( event is InputEventKey and event.is_pressed() ):
		match event.keycode:
			
			KEY_SPACE:
				
				position = Vector2.ZERO
			
			KEY_P: 
				
				velocity.x += 2_000.0
			
			KEY_O:
				
				velocity.y -= 2_000.0
			
			KEY_0:
				
				health_node.recive_event( Heal.new( 1.0 ) )
			
			KEY_9:
				
				health_node.recive_event( Heal.new( 5.0 ) )


func logic_apply_backflip( direction: float ) -> void:
	
	logic_apply_jump( 1.25 )
	
	velocity.x += movement_stats.ground_speed * 0.05 * direction

func logic_apply_longjump( direction: float ) -> void:
	
	logic_apply_jump( 0.75 )
	
	velocity.x += movement_stats.ground_speed * 2.0 * direction


var _i_frame_tween: Tween
@onready var _i_frame_timer := %IFramesTimer as Timer
func start_i_frames() -> void:
	
	hitbox.disable.call_deferred()
	_i_frame_timer.start()
	
	if ( _i_frame_tween ):
		
		_i_frame_tween.kill()
	
	var tween := get_tree().create_tween()
	tween.set_loops(  )
	
	if ( Settings.data.flashing_lights ):
		
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


func _hurt( damage: BaseDamage ) -> void:
	
	start_i_frames()
	
	var cam_effect := CameraShake2D.new()
	cam_effect.duration_max = 0.5
	cam_effect.shake_strength = 25.0 * damage.amount
	
	MainCamera2D.add_effect( cam_effect )
	
	KoboldRadio.player_hitstun.emit( damage )
	
	print( "took: ", damage.amount, " HP: ", health_node.health.current )

func _death() -> void:
	
	KoboldRadio.player_died.emit()
	# enter a dead state here ig
	
	# simulate reciving the dead signal
	var input := InputEventAction.new()
	input.action = &"Pause"
	input.pressed = true
	Input.parse_input_event( input )
	
	state_machine.change_state( PlayerDead.STATE_NAME )
	model.scale.y = 0.1


func _on_i_frames_timer_timeout() -> void:
	
	end_i_frames()
