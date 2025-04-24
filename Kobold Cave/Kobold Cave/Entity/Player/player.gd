@tool
extends Entity
class_name Player
## The playr
## 
## yuyg


const ANIM_RESET := &"RESET"

const ANIM_RUN := &"Run"
const ANIM_IDLE := &"Idle"

const ANIM_RUN_CROUCHED := &"RunCrouched"
const ANIM_IDLE_CROUCHED := &"IdleCrouched"

const ANIM_FALL := &"Fall"
const ANIM_JUMP := &"Jump"

const ANIM_HURT := &"Hurt"
const ANIM_DEAD := &"Dead"


@export var bomb_thrower: BombThrower
@export var hitbox: Hitbox2D
@export var state_machine: StateMachine


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
			
			KEY_F2:
				
				var params := ExplosionParameters.new()
				params.position = get_global_mouse_position()
				params.radius *= randf() * 2.0
				ExplosionServer.create_explosion( params )

func _exit_tree() -> void:
	
	Engine.time_scale = 1.0

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	DragonControler.tree_paused.connect( _on_tree_paused, CONNECT_DEFERRED )
	
	KoboldRadio.ui_connect_health.emit( health_node.health )
	KoboldRadio.ui_connect_bombs.emit( bomb_thrower )


func out_of_bounds() -> void:
	
	KoboldRadio.player_reset_needed.emit( self )
	# the wolrd pausing causes this to happen twice
	#await get_tree().create_timer( 0.5 ).timeout
	health_node.recive_event( Damage.new( 1 ) )


func _hurt( damage: Damage ) -> void:
	
	if ( health_node.health.current > 0 ):
		
		state_machine.change_state( PlayerHitStun.STATE_NAME )
	
	var cam_effect := CameraShake2D.new()
	cam_effect.duration_max = 0.25
	cam_effect.shake_strength = 25.0 * damage.amount
	
	MainCamera2D.add_effect( cam_effect )
	
	KoboldRadio.player_hitstun.emit( damage )

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


func _on_tree_paused( paused: bool ) -> void:
	
	if ( not paused ): return
	
	modulate.a = maxf( 0.5, modulate.a )
	show()
