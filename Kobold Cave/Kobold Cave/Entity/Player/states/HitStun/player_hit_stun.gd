@tool
extends PlayerState
class_name PlayerHitStun

const STATE_NAME := &"PlayerHitStun"

const ARG_STUN_TIME := &"Stun Time"


@export var stun_timer: Timer


func _init() -> void:
	
	_internal_default_args[ ARG_STUN_TIME ] = 0.5
	super()

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	stun_timer.timeout.connect( _on_stun_timer_timeout )

func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	model.animation_player.play( Player.ANIM_HURT )
	model.animation_player.seek( randf(), true )
	model.animation_player.pause()
	
	stun_timer.start( args[ ARG_STUN_TIME ] )

func _leave() -> void:
	
	stun_timer.stop()

func _physics_process( delta: float ) -> void:
	
	if ( player.is_on_floor() ):
		
		movement.logic_walk( player, delta, 0.0 )
	else:
		
		movement.routine_airborne( player, delta, Vector2.ZERO )
	
	player.move_and_slide()


func _on_stun_timer_timeout() -> void:
	
	request_state( PlayerGrounded.STATE_NAME if player.is_on_floor() else PlayerAir.STATE_NAME )
