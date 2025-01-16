extends Node
class_name TimeFlow
## Manages signals related to the flow of time
##
## Emits signals related to the flow of time, and allows local time
## to be scaled as well


## emitted when time scale changes, the provided value is the true scale
signal speed_changed( time_scale: float )


## The local time scale, lets this object move at a different speed
## than others
var local_time_scale: float = 1.0 :
	set( value ):
		
		if ( value > 0.0 ):
			local_time_scale = value
		else:
			local_time_scale = 0.0
		update()
## the true time scale, with global and local scales combined.[br]
## WARNING: Please treat this value as read only!
var time_scale: float = 1.0

## internal tracker for global scale
var _global_scale: float = 1.0


func _ready() -> void:
	if ( Engine.is_editor_hint() ): return
	
	TimeManager.speed_changed.connect( _on_time_manager_speed_changed, CONNECT_DEFERRED )
	_on_time_manager_speed_changed( TimeManager.time_scale )


## called internally when time scale needs to be updated.
## this also emits the speed_changed signal
func update() -> void:
	
	time_scale = local_time_scale * _global_scale
	speed_changed.emit( time_scale )


func _on_time_manager_speed_changed( global_time: float ) -> void:
	
	_global_scale = global_time
	update()
