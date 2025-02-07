extends StateBehaviour


@export var bomb: Bomb
@export var sprite: Node2D
@export var timer: Timer


func _enter() -> void:
	
	timer.start()
	create_tween().tween_property( bomb, ^"modulate", Color.RED, timer.wait_time )


func _on_timer_timeout() -> void:
	
	bomb.explode()
