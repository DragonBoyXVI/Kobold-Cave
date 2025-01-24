@tool
extends Entity
class_name Player
## The playr
## 
## yuyg


func _input( event: InputEvent ) -> void:
	
	if ( event is InputEventKey and event.is_pressed() ):
		match event.keycode:
			
			KEY_SPACE:
				
				position = Vector2.ZERO
			
			KEY_1:
				
				Engine.time_scale = 0.05
			
			KEY_2:
				
				Engine.time_scale = 1.0
			
			KEY_P: 
				
				velocity.x += 2_000.0
			
			KEY_O:
				
				velocity.y -= 2_000.0


func logic_apply_backflip( direction: float ) -> void:
	
	logic_apply_jump( 1.25 )
	
	velocity.x += movement_stats.ground_speed * 0.05 * direction

func logic_apply_longjump( direction: float ) -> void:
	
	logic_apply_jump( 0.75 )
	
	velocity.x += movement_stats.ground_speed * 2.0 * direction
