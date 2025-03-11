@tool
extends Area2D
class_name AreaTrigger2D
## An area that triggers [TriggerResponse] kids when a 
## player enters
## 
## ditto


signal enabled
signal disabled

signal player_entered( player: Player )
signal player_left( player: Player )


## if true, run the enter callback
@export var run_enter: bool :
	set( value ):
		
		run_enter = value
		propagate_call( &"update_configuration_warnings" )
		propagate_call( &"notify_property_list_changed" )
## if true, run the left callback
@export var run_leave: bool :
	set( value ):
		
		run_leave = value
		propagate_call( &"update_configuration_warnings" )
		propagate_call( &"notify_property_list_changed" )


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )


func run_loop_enter( player: Player ) -> void:
	
	var children := get_children()
	for child: Node in children:
		
		if ( child is TriggerResponse ):
			
			child.player_enter( player )

func run_loop_leave( player: Player ) -> void:
	
	var children := get_children()
	for child: Node in children:
		
		if ( child is TriggerResponse ):
			
			child.player_leave( player )


func _on_body_entered( node: Node2D ) -> void:
	if ( not run_enter ): return
	
	if ( node is Player ):
		
		run_loop_enter( node )
		player_entered.emit( node )

func _on_body_exited( node: Node2D ) -> void:
	if ( not run_leave ): return
	
	if ( node is Player ):
		
		run_loop_leave( node )
		player_left.emit( node )
