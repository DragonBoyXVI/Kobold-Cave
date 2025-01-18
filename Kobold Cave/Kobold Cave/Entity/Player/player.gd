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
