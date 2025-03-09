@tool
extends AreaTrigger2D
class_name TriggerEnemySpawner
## spawns enemies when the player enters it
##
## ditto

@export var enemy_scene: PackedScene: 
	set( new_scene ):
		update_configuration_warnings.call_deferred()
		
		enemy_scene = new_scene
@export var spawn_timer: Timer: 
	set( new_timer ):
		update_configuration_warnings.call_deferred()
		
		spawn_timer = new_timer
@export var spawn_limit: int = 1:
	set( value ):
		
		spawn_limit = maxi( 0, value )

var existing_spawns: int = 0

@export var spawn_point: Marker2D


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not enemy_scene ):
		
		const text := "Needs a scene to spawn!"
		warnings.append( text )
	
	if ( not spawn_timer ):
		
		const text := "needs a timer!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered )
		return
	
	spawn_timer.timeout.connect( _on_timer_timeout )


func _player_entered( _player: Player ) -> void:
	
	spawn_timer.start()

func _player_left( _player: Player ) -> void:
	
	spawn_timer.stop()


func get_spawn_point() -> Vector2:
	
	if ( spawn_point ):
		
		return spawn_point.global_position
	
	return global_position


func _on_timer_timeout() -> void:
	
	if ( existing_spawns >= spawn_limit ): return
	existing_spawns += 1
	
	var spawned_thing: Node2D = enemy_scene.instantiate()
	spawned_thing.position = get_spawn_point()
	
	spawned_thing.tree_exited.connect( _on_spawn_tree_exited )
	
	get_tree().current_scene.add_child( spawned_thing )

func _on_spawn_tree_exited() -> void:
	
	existing_spawns -= 1

func _util_on_child_entered( node: Node ) -> void:
	
	if ( node is Timer and not spawn_timer ):
		
		spawn_timer = node
	elif( node is Marker2D and not spawn_point ):
		
		spawn_point = node
