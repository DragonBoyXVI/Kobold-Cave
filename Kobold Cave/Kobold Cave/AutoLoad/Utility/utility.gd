extends Node


## is true if the game manager is loading a scene
var in_level_trans := false

func create_tween_style( myself: Node ) -> Tween:
	
	var tween := myself.create_tween()
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	return tween
