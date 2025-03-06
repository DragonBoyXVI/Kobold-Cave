@icon( "res://Dragon Game Template/Icons/States/state_behaviour.png" )
extends State
class_name StateBehaviour
## Base scene for states in a state machine
##
## This base class should be extended in a script and used to add 
## state behaviours in a state machine.
## The state shouldn't care about the tree its in, so export your dependancies!


## emitted when the state is entered
signal entered
## emitted when the state is left
signal left


## emitted when this state wants to change to another state
signal state_change_requested( state_name: String, args: Array[ Variant ] )
## emitted when this state should exit the [StateMachine] to its top
signal state_top_requested


## if true, the parent [StateMachine] will defer all state change requests.[br]
## changing this at runtime has no effect
@export var defer_change := false
## default enter arguments
@export var default_enter_args: Array = []


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		# stop editor from whining about tool states
		# be sure to call super()
		set_process( false )
		set_physics_process( false )
		set_process_input( false )
		set_process_unhandled_input( false )
		set_process_shortcut_input( false )


## Called by a state machine to enter this state.
## also handles default args and given args
func enter( args: Array[ Variant ] = [] ) -> void:
	
	if ( default_enter_args.size() > args.size() ):
		
		args.resize( default_enter_args.size() )
	
	for i: int in args.size():
		
		if ( args[ i ] == null ):
			
			args[ i ] = default_enter_args[ i ]
	
	_enter( args )
	entered.emit()

## Called by a state machine to leave this state
func leave() -> void:
	
	_leave()
	left.emit()

## Called by a state machine to check if the current state
## can leave and enter into the new state
func state_change_is_valid( new_state: StateBehaviour ) -> bool:
	
	return _change_is_valid( new_state )


## virtual for the enter function
func _enter( _args: Array[ Variant ] ) -> void:
	pass

## virtual for the leave function
func _leave() -> void:
	pass

## virtual for the state change is valid function.
func _change_is_valid( _new_state: StateBehaviour ) -> bool:
	
	return true


## Call this function to request a state change
func request_state( state_name: StringName, args: Array[ Variant ] = [] ) -> void:
	
	state_change_requested.emit( state_name, args )

## Call this to make the parent state machine return to its
## parent state machine
## 
## WARNING: idk if this works nicely or not, use at own risk =3
func request_top() -> void:
	
	state_top_requested.emit()
