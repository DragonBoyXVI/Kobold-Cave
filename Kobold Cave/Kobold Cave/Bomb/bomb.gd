
extends CharacterBody2D
class_name Bomb
## a bomb that explodes
##
## woaoaoaw, pip ebomb, so cool....


const TIME_FLYING: float = 30.0
const TIME_FUSE_LIT: float = 3.0
const TIME_START_SHAKE: float = 2.0

const SHAKE_STRENGTH: float = 16.0
const ROTATION_DIVISOR: float = 256.0


@export var hitbox: ObjHitbox2D
@export var visual: Node2D


var state_machine: StateMachineLite = StateMachineLite.new()
enum {
	STATE_FLYING,
	STATE_LIT
}

var is_shaking: bool = false

var timer_flying: SceneTreeTimer
var timer_explode: SceneTreeTimer
var timer_shake: SceneTreeTimer


func _init() -> void:
	
	state_machine.state_entered.connect( _on_state_machine_entered_state )
	state_machine.state_left.connect( _on_state_machine_left_state )

func _ready() -> void:
	
	state_machine.change_state( STATE_FLYING )

func _process( delta: float ) -> void:
	
	if ( is_shaking ):
		
		var shake_offset: Vector2 = Vector2.from_angle( TAU * randf() )
		shake_offset *= SHAKE_STRENGTH * randf()
		
		visual.position = shake_offset
	elif ( state_machine.state_current_index == STATE_FLYING ):
		
		var rotation_factor: float = velocity.x / ROTATION_DIVISOR * delta
		visual.rotation += rotation_factor

func _physics_process( delta: float ) -> void:
	
	
	match state_machine.state_current_index:
		
		STATE_FLYING:
			
			const GRAVITY := 2000.0
			velocity.y += GRAVITY * delta
			
			move_and_slide()
			var collison: KinematicCollision2D = get_last_slide_collision()
			if ( collison ):
				
				state_machine.change_state( STATE_LIT )



func explode() -> void:
	
	hitbox.disable.call_deferred()
	
	#await get_tree().physics_frame
	var params := ExplosionParameters.new()
	params.radius = 160.0
	params.position = global_position
	params.exclude = [ get_rid(), hitbox.get_rid() ]
	ExplosionServer.create_explosion( params )
	
	queue_free()




func _on_state_machine_entered_state( state_id: int ) -> void:
	
	if ( state_id == STATE_FLYING ):
		
		timer_flying = get_tree().create_timer( TIME_FLYING, false, true )
		timer_flying.timeout.connect( _on_flying_timer_timeout )
	elif( state_id == STATE_LIT ):
		
		timer_explode = get_tree().create_timer( TIME_FUSE_LIT, false, true )
		timer_explode.timeout.connect( _on_explode_timer_timeout )
		
		var tween := create_tween()
		tween.tween_property( visual, ^"modulate", Color.RED, TIME_FUSE_LIT )
		
		timer_shake = get_tree().create_timer( TIME_START_SHAKE )
		timer_shake.timeout.connect( _on_shake_timer_timeout )

func _on_state_machine_left_state( state_id: int ) -> void:
	
	if ( state_id == STATE_FLYING ):
		if ( timer_flying ):
			
			timer_flying.set_block_signals( true )
			timer_flying = null


func _on_flying_timer_timeout() -> void:
	
	explode()

func _on_explode_timer_timeout() -> void:
	
	explode()

func _on_shake_timer_timeout() -> void:
	
	is_shaking = true


func _on_hitbox_2d_recived_event( event: HurtboxEvent ) -> void:
	
	if ( event is Damage ):
		
		explode()
