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

## the state this requests when we want to return to the 
## parent state machine
var top_state: StateBehaviour :
	set( value ):
		
		if ( top_state == value ): return
		
		notify_property_list_changed.call_deferred()
		update_configuration_warnings.call_deferred()
		
		top_state = value


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ): 
		
		child_order_changed.connect( update_configuration_warnings )
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
	
	
	if ( initial_state ):
		
		if ( not children.has( initial_state ) ):
			
			initial_state = null
			
			const text := "Initial state must be a child of this [StateMachine]!"
			warnings.append( text )
			push_warning( text )
		
		pass
	else:
		
		const text := "No initial state set.\nSelect a child [StateBehaviour] to be the initial state."
		warnings.append( text )
	
	if ( get_parent() is StateMachine ):
		
		if ( not top_state ):
			
			const text := "Set a top state for the parent to return to."
			warnings.append( text )
		elif ( top_state in children ):
			
			const text := "Top state cannot be a child of this [StateMachine]"
			warnings.append( text )
			
			top_state = null
	else:
		
		top_state = null
	
	return warnings

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( get_parent() is StateMachine ):
		
		properties.append( {
			"name": "request_top_state",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": "StateMachine"
		} )
	
	return properties

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"initial_state",
		"request_top_state",
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		&"initial_state": return null
		&"request_top_state": return null
	
	return null


func _enter( _args: Dictionary ) -> void:
	
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
	if ( state_to_add.defer_change ):
		
		state_to_add.state_change_requested.connect( _on_child_state_change_requested, CONNECT_DEFERRED )
		state_to_add.state_top_requested.connect( _on_child_request_top_state, CONNECT_DEFERRED )
	else:
		
		state_to_add.state_change_requested.connect( _on_child_state_change_requested )
		state_to_add.state_top_requested.connect( _on_child_request_top_state )
	
	pass

## Use this to change states
func change_state( state_name: StringName, args: Dictionary[ StringName, Variant ] = {} ) -> void:
	
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
	
	pass


## return true if this machine has a state
func has_state( state_name: StringName ) -> bool:
	
	return stored_states.has( state_name )

## return true if this in in the current state
func is_in_state( state_name: StringName ) -> bool:
	
	if ( not current_state ): return false
	
	return state_name == current_state.name


func _on_child_state_change_requested( state_name: StringName, args: Dictionary[ StringName, Variant ] ) -> void:
	
	change_state( state_name, args )

func _on_child_request_top_state(  ) -> void:
	
	request_state( top_state.name )
