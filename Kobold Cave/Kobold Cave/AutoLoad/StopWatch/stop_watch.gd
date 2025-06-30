
extends Node


signal started
signal stopped


var is_started: bool = false

var elapsed_time: float = 0.0


func start() -> void:
	
	unpause()
	is_started = true
	elapsed_time = 0.0
	started.emit()

func pause() -> void:
	
	process_mode = Node.PROCESS_MODE_DISABLED

func unpause() -> void:
	
	process_mode = Node.PROCESS_MODE_INHERIT

func stop() -> void:
	
	is_started = false
	stopped.emit()


func time_to_string( time: float ) -> String:
	
	const FORMAT: String = "{min}:{sec}"
	
	var minutes: int = floori( time / 60.0 )
	var seconds: float = time - ( minutes * 60.0 )
	
	return FORMAT.format( { "min": minutes, "sec": ( "%.02f" % seconds ) } )


func _process( delta: float ) -> void:
	
	if ( not is_started ): return
	
	elapsed_time += delta
