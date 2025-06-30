@tool
extends Entity
class_name ExplodingGhost


@export var auto_detonate: bool = true
@export var bomb_thrower: BombThrower
@export var lifespan_timer: Timer

var is_shaking: bool = false


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		auto_detonate = false
		return

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	if ( not auto_detonate ): return
	
	velocity = Vector2.from_angle( randf() * TAU ) * 256.0
	
	lifespan_timer.timeout.connect( _on_life_timer_timeout )
	
	var tween := create_tween()
	tween.set_parallel(  )
	tween.tween_property( model, ^"modulate", Color.RED, lifespan_timer.wait_time )
	tween.tween_callback( _on_shake_timer_timeout ).set_delay( lifespan_timer.wait_time * 0.8 )

func _process( _delta: float ) -> void:
	
	if ( not is_shaking ): return
	
	const shake_dist: float = 16.0
	
	var shake_offset: Vector2 = Vector2.from_angle( TAU * randf() ) * shake_dist
	model.position = shake_offset

func _on_died() -> void:
	
	const bombs_to_throw: int = 5#4
	
	for index: int in bombs_to_throw:
		
		var throw_angle: float = ( index / float( bombs_to_throw ) ) * TAU
		bomb_thrower.throw_bomb( Vector2.from_angle( throw_angle ) )
	
	queue_free()


func _on_shake_timer_timeout() -> void:
	
	is_shaking = true

func _on_life_timer_timeout() -> void:
	
	damage_profile.take_damage( Damage.new( 55555 ) )
