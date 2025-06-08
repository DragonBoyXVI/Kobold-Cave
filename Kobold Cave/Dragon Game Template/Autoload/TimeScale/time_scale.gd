
extends Object
class_name TimeControl
## provides control over time that scratches my brain
##
## slow timetism


enum CHANGE_TYPE {
	
	INSTANT,
	TWEEN,
	
}


const TWEEN_TIME: float = 0.1


## instantly set time scale
static func change_time_scale( new_scale: float ) -> void:
	
	Engine.time_scale = new_scale
	emit_changed( new_scale, CHANGE_TYPE.INSTANT )

## changes time over time
static func change_time_scale_tween( new_scale: float ) -> void:
	
	var tween: Tween = Engine.get_main_loop().create_tween()
	tween.set_ignore_time_scale()
	
	tween.tween_property( Engine, ^"time_scale", new_scale, TWEEN_TIME )
	
	emit_changed( new_scale, CHANGE_TYPE.TWEEN )

## connect to the time changed callback
static func connect_to_time_changed( callback: Callable, flags: int = 0 ) -> void:
	
	DragonRadio.time_scale_changed.connect( callback, flags )


static func emit_changed( new_scale: float, type: CHANGE_TYPE ) -> void:
	DragonRadio.time_scale_changed.emit( new_scale, type )
