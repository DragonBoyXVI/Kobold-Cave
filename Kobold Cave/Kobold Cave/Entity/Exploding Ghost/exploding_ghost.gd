@tool
extends Entity
class_name ExplodingGhost


@export var bomb_thrower: BombThrower

var is_shaking: bool = false

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	const death_time: float = 30.0
	
	var timer := get_tree().create_timer( death_time, false, true )
	timer.timeout.connect( _on_life_timer_timeout )
	
	var tween := create_tween()
	tween.tween_property( model, ^"modulate", Color.RED, death_time )

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
