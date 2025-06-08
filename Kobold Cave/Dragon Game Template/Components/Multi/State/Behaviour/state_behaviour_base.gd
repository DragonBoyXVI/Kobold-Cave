@icon( "res://Dragon Game Template/Icons/States/state_behaviour.png" )
@tool
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
signal state_change_requested( state_name: String, args: Dictionary[ StringName, Variant ] )


const NO_STATE := &"NOSTATE"


## if true, the parent [StateMachine] will defer all state change requests.[br]
## changing this at runtime has no effect
@export var defer_change := false
@export_group( "Args" )
## The default arguments used when entering this state[br]
## Any added arguments will non-destructivley overide default arguments
@export var default_args: Dictionary[ StringName, Variant ] = {}
## when using _init(), change this to set the default args,
## and call super() after
var _internal_default_args: Dictionary[ StringName, Variant ] = {}


func _init() -> void:
	
	default_args = _internal_default_args

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		# stop editor from whining about tool states
		# be sure to call super()
		set_process( false )
		set_physics_process( false )
		set_process_input( false )
		set_process_unhandled_input( false )
		set_process_shortcut_input( false )
		return

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"default_args"
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		&"default_args": return _internal_default_args
	
	return null


## Called by a state machine to enter this state
func enter( args: Dictionary[ StringName, Variant ] = {} ) -> void:
	
	_enter( args.merged( default_args ) )
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
func _enter( _args: Dictionary[ StringName, Variant ] ) -> void:
	pass

## virtual for the leave function
func _leave() -> void:
	pass

## virtual for the state change is valid function. [br]
## by default, entering a state youre already in is disallowed, overwrite to change that
func _change_is_valid( new_state: StateBehaviour ) -> bool:
	
	if ( name == new_state.name ):
		return false
	
	return true


## Call this function to request a state change
func request_state( state_name: StringName, args: Dictionary[ StringName, Variant ] = {} ) -> void:
	
	state_change_requested.emit( state_name, args )
