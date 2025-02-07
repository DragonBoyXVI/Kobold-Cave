extends StateBehaviour


@export var bomb: Bomb
@export var sprite: Node2D


func _process( delta: float ) -> void:
	
	const rotation_speed := deg_to_rad( 25.0 )
	const rotation_factor := 500.0
	
	var rotation_delta := delta * rotation_speed * ( bomb.velocity.x / rotation_factor )
	sprite.rotation += rotation_delta

func _physics_process( delta: float ) -> void:
	
	bomb.logic_gravity( delta )
	bomb.move_and_slide()
	
	var collision := bomb.get_last_slide_collision()
	if ( collision ):
		
		request_state( &"Exploding" )
