extends StateBehaviour


var slow_factor := 1.0


func _enter() -> void:
	
	slow_factor = 1.0
	if ( Input.is_action_pressed( "Slow" ) ):
		slow_factor = 0.05

func _leave() -> void:
	
	MainCamera2D.zoom = Vector2.ONE


func _process( delta: float ) -> void:
	delta = ( 1.0 / Engine.get_frames_per_second() )
	
	var move_input := Input.get_vector( "Move Left", "Move Right", "Move Up", "Move Down" )
	move_input *= slow_factor
	
	const speed := 1200.0
	MainCamera2D.global_position += ( speed * delta ) * move_input
	
	MainCamera2D.logic_camera_effects( delta )

func _input( event: InputEvent ) -> void:
	
	if ( event.is_action( "Slow" ) ):
		
		if ( event.is_pressed() ):
			slow_factor = 0.05
		elif ( event.is_released() ):
			slow_factor = 1.0
		
		return
	
	if ( event.is_action_released( "Zoom In" ) ):
		
		MainCamera2D.zoom += Vector2.ONE * 0.1 * slow_factor
		
		get_window().set_input_as_handled()
		return
	
	if ( event.is_action_released( "Zoom Out" ) ):
		
		MainCamera2D.zoom -= Vector2.ONE * 0.1 * slow_factor
		
		get_window().set_input_as_handled()
		return
