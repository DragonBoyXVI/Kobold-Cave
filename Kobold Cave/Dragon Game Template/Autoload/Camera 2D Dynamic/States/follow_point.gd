extends StateBehaviour


const idle_state := &"Idle"


var point := Vector2.ZERO


func _process( delta: float ) -> void:
	
	MainCamera2D.routine_camera( point, delta )
