extends StateBehaviour


@export var bomb: Bomb
@export var sprite: Node2D
@export var timer: Timer


func _ready() -> void:
	super()
	
	timer.timeout.connect( _on_timer_timeout )

func _enter( _args: Dictionary ) -> void:
	
	timer.start()
	sprite.rotation = TAU * randf()

func _leave() -> void:
	
	timer.stop()

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


func _on_timer_timeout() -> void:
	
	bomb.explode()
