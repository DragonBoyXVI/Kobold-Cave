@tool
extends ScrollContainer
#class_name DragonScrollBox
## text
## 
## text


## how many pixels per second you scroll via stick
@export var horizontal_scroll_speed := 200.0
## how many pixels per second you scroll via stick
@export var vertical_scroll_speed := 200.0


func _physics_process( delta: float ) -> void:
	
	#if ( not is_visible_in_tree() ): return
	
	var dir := Input.get_vector( &"Move Left", &"Move Right", &"Move Up", &"Move Down" )
	scroll_horizontal += int( horizontal_scroll_speed * dir.x * delta )
	scroll_vertical += int( vertical_scroll_speed * dir.y * delta )
	
	print( dir )
