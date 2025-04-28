extends StateBehaviour


@export var bomb: Bomb
@export var sprite: Node2D
@export var timer: Timer
@export var shake_timer: Timer


var is_shaking: bool = false


func _enter( _args: Dictionary ) -> void:
	
	timer.start()
	shake_timer.start()
	
	var tween := create_tween()
	tween.tween_property( sprite, ^"modulate", Color.RED, timer.wait_time )
	tween.tween_property( sprite, ^"scale", Vector2( 0.9, 0.9 ), timer.wait_time )


func _process( _delta: float ) -> void:
	
	if ( is_shaking ):
		
		const dist := 4.0
		var offset: Vector2 = Vector2.from_angle( TAU * randf() ) * dist
		sprite.position = offset


func _on_timer_timeout() -> void:
	
	bomb.explode()

func _on_shake_timer_timeout() -> void:
	
	is_shaking = true
