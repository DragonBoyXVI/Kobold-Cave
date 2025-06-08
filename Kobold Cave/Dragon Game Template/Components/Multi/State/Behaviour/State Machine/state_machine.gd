@tool
@icon( "res://Dragon Game Template/Icons/States/state_machine.png" )
extends StateBehaviour
class_name StateMachine
## Node based state machine pattern.
##
## A node based state machine that uses [StateBehaviour] children to
## dicate this scene's behavior.


## the state we just left (still in the state, but it's "leave" has been called)
signal state_left( state: StateBehaviour )
## the state we just entered (after it's "enter" has been called)
signal state_entered( state: StateBehaviour )


## does nothing except turn off the no initial state warning
@export var starts_in_no_state: bool = false :
	set( value ):
		
		starts_in_no_state = value
		update_configuration_warnings()
## the state we enter when readied
@export var initial_state: StateBehaviour :
	set( state ):
		
		if ( initial_state == state ): return
		
		update_configuration_warnings.call_deferred()
		
		initial_state = state


## states this machine has access to, populated at creation and never updated!
var stored_states: Dictionary[ StringName, StateBehaviour ] = {}
## the current state. To change this, use [annotation StateMachine.change_state]
var current_state: StateBehaviour


func _init() -> void:
	super()
	
	if ( Engine.is_editor_hint() ): 
		
		child_order_changed.connect( update_configuration_warnings )
		return

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ): 
		return
	
	# poll children
	for child in get_children():
		
		if ( child is StateBehaviour ):
			
			add_state( child )
		else:
			
			push_warning( "State machine should have StateBehaviour children!" )
	
	# go to initial state if not being used as a substate
	if ( initial_state and get_parent() is not StateMachine ):
		
		change_state( initial_state.name )
	
	pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	var children := get_children()
	var children_count := get_child_count()
	
	
	if ( children_count > 0 ):
		
		var has_state_kids := false
		for child: Node in children:
			
			if ( child is StateBehaviour ):
				
				has_state_kids = true
				break
		
		if ( not has_state_kids ):
			
			const text := "No [StateBehaviour] children were found."
			warnings.append( text )
		
		pass
	else:
		
		const text := "No states added!\nAdd a state by creating a [StateBehavour] child."
		warnings.append( text )
	
	
	if ( starts_in_no_state ):
		
		pass
	elif ( initial_state ):
		
		if ( not children.has( initial_state ) ):
			
			initial_state = null
			
			const text := "Initial state must be a child of this [StateMachine]!"
			warnings.append( text )
			push_warning( text )
		
		pass
	else:
		
		const text := "No initial state set.\nSelect a child [StateBehaviour] to be the initial state."
		warnings.append( text )
	
	return warnings



func _enter( _args: Dictionary[ StringName, Variant ] ) -> void:
	
	if ( initial_state ):
		
		change_state( initial_state.name )

func _leave() -> void:
	
	if ( current_state ):
		
		current_state.leave()
		state_left.emit( current_state )
		current_state.disable()
		
		current_state = null



## used to add a state to this state machine
func add_state( state_to_add: StateBehaviour ) -> void:
	
	# error checking
	if ( stored_states.has( state_to_add.name ) ):
		
		push_error( name, ": ", state_to_add.name, ": duplicate state name!" )
		return
	
	# add the state
	stored_states[ state_to_add.name ] = state_to_add
	state_to_add.disable()
	
	# connect reqeust signal
	var signal_flags: int = 0
	if ( state_to_add.defer_change ): signal_flags |= CONNECT_DEFERRED
	
	state_to_add.state_change_requested.connect( _on_child_state_change_requested, signal_flags )

## Use this to change states
func change_state( state_name: StringName, args: Dictionary[ StringName, Variant ] = {} ) -> void:
	
	# dont enter a state youre already in
	if ( not current_state and state_name == NO_STATE ): return
	
	# no state override
	if ( state_name == NO_STATE ):
		
		current_state.leave()
		state_left.emit( current_state )
		current_state.disable()
		current_state = null
		
		return
	
	# double check we have this state
	if ( stored_states.has( state_name ) ):
		
		var new_state: StateBehaviour = stored_states[ state_name ]
		
		if ( current_state ):
			
			# cancel if this state cant be changed
			if ( not current_state.state_change_is_valid( new_state ) ):
				return
			
			current_state.leave()
			state_left.emit( current_state )
			current_state.disable()
		
		current_state = new_state
		current_state.enable()
		current_state.enter( args )
		state_entered.emit( current_state )
		
		pass
	else:
		
		push_error( state_name, ": Does not exist!" )


## return true if this machine has a state
func has_state( state_name: StringName ) -> bool:
	
	return stored_states.has( state_name )

## return true if this in in the current state
func is_in_state( state_name: StringName ) -> bool:
	
	if ( not current_state ): return false
	
	return state_name == current_state.name


func _on_child_state_change_requested( state_name: StringName, args: Dictionary[ StringName, Variant ] = {} ) -> void:
	
	change_state( state_name, args )
