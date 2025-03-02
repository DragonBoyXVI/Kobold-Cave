@tool
extends AreaTrigger2D
class_name TriggerSetSpawn
## Sets your spawn point when entered
##
## ditto


@export var new_spawn: Marker2D : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		new_spawn = value


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not new_spawn ):
		
		const text := "Set a new spawn point for this to use. Respawning uses global coords, so it can be a child of this trigger!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered )
		return

func _player_entered( _player: Player ) -> void:
	
	KoboldRadio.level_set_spawn.emit( new_spawn )


func _util_on_child_entered( node: Node ) -> void:
	
	if ( node is Marker2D and not new_spawn ):
		
		new_spawn = node
