@tool
extends Node2D
class_name TriggerResponse
## A node meant to be a child of a [AreaTrigger2D],
## runs code when the player enters the trigger.
##
## Sometimes we need functions taht are node exclusive,
## like exporting refs to nodes, hence why this is a 
## node based system


var ticks_ran: int = 0


@export_group( "Disable", "disable_" )
## if true, this trigger never runs
@export var disabled: bool = false
## if true, this gets disabled after being activated x times
@export var disable_when_ticked: bool = false
## how many times this can be activated before getting disabled
@export var disable_at_tick: int = 1
## when do we count a activation tick
@export_flags( "Enter", "Leave" ) var disable_tick_time: int = 2
@export_group( "Parent", "parent_" )
@export_subgroup( "Respect", "respect_" )
## if true, runs enter when the parent calls for it
@export var parent_respect_enter: bool = true :
	set( value ):
		
		parent_respect_enter = value
		update_configuration_warnings()
		notify_property_list_changed()
## if true, runs leave when the parent calls for it
@export var parent_respect_leave: bool = true :
	set( value ):
		
		parent_respect_leave = value
		update_configuration_warnings()
		notify_property_list_changed()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( get_parent() is not AreaTrigger2D ):
		
		const text := "Please use this as a child of an AreaTrigger2D!"
		warnings.append( text )
	
	if ( not editor_is_enter_callable() and not editor_is_leave_callable() ):
		
		const text := "Neither enter or leave can be called"
		warnings.append( text )
	
	return warnings

func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_PARENTED:
			
			update_configuration_warnings()
		
		NOTIFICATION_POST_ENTER_TREE:
			
			update_configuration_warnings()

func _ready() -> void:
	pass


func tick_logic() -> void:
	if ( not disable_when_ticked ): return
	
	ticks_ran += 1
	
	if ( ticks_ran >= disable_at_tick ):
		
		disabled = true

func editor_is_enter_callable() -> bool:
	
	var parent := get_parent()
	if ( not parent ): return true
	if ( not parent.is_node_ready() ): return true
	if ( parent is AreaTrigger2D ):
		
		return parent_respect_enter and parent.run_enter
	else:
		
		return false

func editor_is_leave_callable() -> bool:
	
	var parent := get_parent()
	if ( not parent ): return true
	if ( not parent.is_node_ready() ): return true
	if ( parent is AreaTrigger2D ):
		
		return parent_respect_leave and parent.run_leave
	else:
		
		return false


func player_enter( player: Player ) -> void:
	if ( disabled ): return
	if ( not parent_respect_enter ): return
	
	_player_enter( player )
	
	if ( disable_tick_time & 0b1 ):
		
		tick_logic()

func player_leave( player: Player ) -> void:
	if ( disabled ): return
	if ( not parent_respect_leave ): return
	
	_player_leave( player )
	
	if ( disable_tick_time & 0b10 ):
		
		tick_logic()

## vitual
func _player_enter( _player: Player ) -> void:
	pass

## virtual
func _player_leave( _player: Player ) -> void:
	pass


func _util_child_entered_tree( _node: Node ) -> void:
	pass
