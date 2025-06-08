
extends Object
class_name KoboldUtility
## class that provides utility funcs
## 
## Provides some useful methods to be used throughout the game


## is true if the game manager is loading a scene
static var in_level_trans := false


static func set_camera_zoom_tween( zoom: Vector2, time: float = 0.15 ) -> void:
	
	if ( not MainCamera2D ):
		await Engine.get_main_loop().physics_frame
	
	if ( not MainCamera2D.is_node_ready() ):
		await MainCamera2D.ready
	
	var tween := MainCamera2D.create_tween()
	tween.tween_property( MainCamera2D, ^"zoom", zoom, time )

static func create_tween_style( myself: Node ) -> Tween:
	
	var tween := myself.create_tween()
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	return tween
