extends TimeFlow
#class_name FlowTimer
## Recreation of the [Timer] node that reacts to TimeManager changes.
##
## This is a custom [Timer] node that reacts to TimeManager chnages.
## This tries to mirror [Timer] 1:1.[br]
## Is this reinventing the wheel? Yes. Yes it is.


## what process to process this timer in
enum TIMER_PROCESS {
	PROCESS, ## _process
	PHYSICS ## _physics_process
}

enum {
	IDLE,
	TICKING,
}


## emitted when the timer hits 0.
signal timeout


## The mode to process this timer in
@export var process_callback: TIMER_PROCESS = TIMER_PROCESS.PROCESS
## the length of the timer. This is changed if you call start() with an arg
@export_range( 0.01, pow( 5, 5 ) ) var wait_time: float = 1.0 :
	set( value ):
		
		if ( value > 0.0 ):
			wait_time = value
		else:
			wait_time = 0.0
## if true, this timer stops when it reaches 0.
@export var one_shot: bool = false
## if true, this timer starts automatically when entering the tree
@export var autostart: bool = false

## if true, this timer will not process. even if start() is called.
var paused: bool = false
## the time left
var time_left: float = 0.0

var _state := IDLE


func _ready() -> void:
	super()
	
	if ( autostart ):
		start()

func _process( delta: float ) -> void:
	if ( paused ): return
	if ( _state != TICKING ): return
	if ( process_callback != TIMER_PROCESS.PROCESS ): return
	
	delta *= time_scale
	
	time_left -= delta
	if ( time_left <= 0.0 ):
		
		_timeout()

func _physics_process( delta: float ) -> void:
	if ( paused ): return
	if ( _state != TICKING ): return
	if ( process_callback != TIMER_PROCESS.PHYSICS ): return
	
	delta *= time_scale
	
	time_left -= delta
	if ( time_left <= 0.0 ):
		
		_timeout()


## starts the timer, provide a value above 0 to set a new wait time
func start( time: float = -1 ) -> void:
	
	_state = TICKING
	
	if ( time > 0.0 ):
		wait_time = time
	
	time_left = wait_time

## stops the timer without timing it out.
func stop() -> void:
	
	_state = IDLE
	time_left = 0.0

## returns true if the timer has not been started
func is_stopped() -> bool:
	
	return ( _state == IDLE )


func _timeout() -> void:
	timeout.emit()
	
	if ( one_shot ):
		
		_state = IDLE
		time_left = 0.0
	else:
		
		time_left += wait_time
