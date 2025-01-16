extends Node
## Time Manager lets you change the flow of time, wow
##
## Time Manager gives you control of the flow of time without
## changing Engine.timescale.[br]
## Time changes are handled via [TimeFlow] nodes, but you can also
## connect signal directly


## emitted when the speed of time changes
signal speed_changed( time_scale: float )


## the current time scale
var time_scale: float = 1.0 :
	set( value ):
		
		if ( value > 0.0 ):
			time_scale = value
		else:
			time_scale = 0.0
		
		speed_changed.emit( value )
