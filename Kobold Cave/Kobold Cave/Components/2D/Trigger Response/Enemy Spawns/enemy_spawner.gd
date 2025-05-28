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
## the scene to instance, must be at minimal a [Node2D]
@export var spawn_scene: PackedScene:
	set( new_scene ):
		
		spawn_scene = new_scene
		update_configuration_warnings()
## Optional marker to spawn enemies at
@export var spawn_marker: Marker2D:
	set( new_marker ):
		
		spawn_marker = new_marker
		update_configuration_warnings()
## how the time between spawns
@export var spawn_time: float = 1.25:
	set( new ):
		
		spawn_time = maxf( new, 0.05 )


var spawn_count: int = 0
var _timer: SceneTreeTimer


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not editor_is_leave_callable() ):
		
		const text := "This cannot call leave. if leave is not called, enemies will spawn endlessly."
		warnings.append( text )
	
	if ( not spawn_scene ):
		
		const text := "This has no scene to spawn!"
		warnings.append( text )
	
	return warnings

func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Marker2D and not spawn_marker ):
		
		spawn_marker = node

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return

func _player_enter( _player: Player ) -> void:
	
	_refresh_timer()

func _player_leave( _player: Player ) -> void:
	
	_timer.set_block_signals( true )
	_timer = null


func _refresh_timer() -> void:
	
	if ( _timer ):
		
		_timer.set_block_signals( true )
	
	_timer = get_tree().create_timer( spawn_time, false, true )
	_timer.timeout.connect( _on_spawn_timer_timeout )


func _on_spawn_timer_timeout() -> void:
	
	_refresh_timer()
	
	if ( spawn_count >= spawn_limit ): return
	spawn_count += 1
	
	var spawn: Node2D = spawn_scene.instantiate()
	if ( spawn_marker ):
		
		spawn.position = spawn_marker.global_position
	else:
		
		spawn.position = global_position
	
	spawn.tree_exited.connect( _on_spawn_exited_tree )
	
	get_tree().current_scene.add_child.call_deferred( spawn )

func _on_spawn_exited_tree() -> void:
	
	spawn_count -= 1
