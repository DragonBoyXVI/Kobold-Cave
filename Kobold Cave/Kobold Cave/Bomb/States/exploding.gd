extends StateBehaviour


@export var bomb: Bomb
@export var sprite: Node2D
@export var timer: Timer


func _enter( _args: Array ) -> void:
	
	timer.start()
	
	var tween := create_tween()
	tween.tween_property( sprite, ^"modulate", Color.RED, timer.wait_time )
	tween.tween_property( sprite, ^"scale", Vector2( 0.95, 0.95 ), timer.wait_time )


func _on_timer_timeout() -> void:
	
	bomb.explode()
