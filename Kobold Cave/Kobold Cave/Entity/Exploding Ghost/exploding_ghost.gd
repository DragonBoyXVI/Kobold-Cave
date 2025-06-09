@tool
extends Entity
class_name ExplodingGhost


@export var bomb_thrower: BombThrower


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	var death_timer := get_tree().create_timer( 30.0, false, true )
	death_timer.timeout.connect( _on_life_timer_timeout )


func _death() -> void:
	
	const bombs_to_throw: int = 5#4
	
	for index: int in bombs_to_throw:
		
		var throw_angle: float = ( index / float( bombs_to_throw ) ) * TAU
		bomb_thrower.throw_bomb( Vector2.from_angle( throw_angle ) )
	
	queue_free()


func _on_life_timer_timeout() -> void:
	
	damage_profile.take_damage( Damage.new( 55555 ) )
