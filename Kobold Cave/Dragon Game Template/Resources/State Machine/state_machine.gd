@icon( "uid://vmg4ays48db7" )
extends RefCounted
class_name StateMachineLite
## A non node based state machine.
## 
## Designed to provide the functionality of the node
## based variant while be much more light weight.


const NO_STATE := -1


## emitted when this state is entered
signal state_entered( state_index: int )
## emitted when this state is exited
signal state_left( state_index: int )


## index id of the current state, -1 is no state
var state_current_index: int = NO_STATE


func change_state( new_index: int ) -> void:
	
	state_left.emit( state_current_index )
	state_current_index = new_index
	state_entered.emit( new_index )
