@tool
extends TriggerResponse
class_name TriggerEnemySpawner
## spawns enemies while the player is inside
##
## ditto


@export_group( "Spawner", "spawn_" )
## how many enemies this can spawn
@export var spawn_limit: int = 1:
	set( value ):
		
		spawn_limit = maxi( 1, value )
@export var spawn_scene: PackedScene:
	set( new_scene ):
		
		spawn_scene = new_scene
		update_configuration_warnings()
@export var spawn_marker: Marker2D:
	set( new_marker ):
		
		spawn_marker = new_marker
		update_configuration_warnings()
@export var spawn_timer: Timer:
	set( new_timer ):
		
		spawn_timer = new_timer
		update_configuration_warnings()


var spawn_count: int = 0


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not editor_is_leave_callable() ):
		
		const text := "This cannot call leave. if leave is not called, enemies will spawn endlessly."
		warnings.append( text )
	
	if ( not spawn_scene ):
		
		const text := "This has no scene to spawn!"
		warnings.append( text )
	
	if ( not spawn_marker ):
		
		const text := "Needs a spawn marker to know where to place stuff"
		warnings.append( text )
	
	if ( not spawn_timer ):
		
		const text := "Needs a timer to know when to spawn"
		warnings.append( text )
	
	return warnings

func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Marker2D and not spawn_marker ):
		
		spawn_marker = node
	elif( node is Timer and not spawn_timer ):
		
		spawn_timer = node

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	spawn_timer.timeout.connect( _on_spawn_timer_timeout )


func _player_enter( _player: Player ) -> void:
	
	spawn_timer.start()

func _player_leave( _player: Player ) -> void:
	
	spawn_timer.stop()


func _on_spawn_timer_timeout() -> void:
	
	if ( spawn_count >= spawn_limit ): return
	spawn_count += 1
	
	var spawn: Node2D = spawn_scene.instantiate()
	spawn.position = spawn_marker.global_position
	
	spawn.tree_exited.connect( _on_spawn_exited_tree )
	
	get_tree().current_scene.add_child.call_deferred( spawn )

func _on_spawn_exited_tree() -> void:
	
	spawn_count -= 1
