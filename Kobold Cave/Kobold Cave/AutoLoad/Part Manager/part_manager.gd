
extends Node2D


class PoolManager:
	
	extends Node2D
	
	const initial_spawns := 5
	
	var spawn_scene: PackedScene
	var avaliable_nodes: Array[ CPUParticles2D ] = []
	
	
	func _ready() -> void:
		
		for i: int in initial_spawns:
			
			new_item()
	
	func new_item() -> void:
		
		var spawn := spawn_scene.instantiate() as CPUParticles2D
		spawn.process_mode = Node.PROCESS_MODE_DISABLED
		
		spawn.finished.connect( _on_particles_finished.bind( spawn ), CONNECT_DEFERRED )
		
		avaliable_nodes.append( spawn )
		add_child( spawn )
	
	func get_item() -> CPUParticles2D:
		
		if ( avaliable_nodes.size() == 0 ):
			
			new_item()
		
		var item := avaliable_nodes.pop_at( 0 ) as CPUParticles2D
		item.process_mode = Node.PROCESS_MODE_ALWAYS
		
		return item
	
	
	func _on_particles_finished( particles: CPUParticles2D ) -> void:
		
		particles.process_mode = Node.PROCESS_MODE_DISABLED
		particles.restart()
		avaliable_nodes.append( particles )


func _init() -> void:
	
	z_index = 6


func new_manager( scene_path: String ) -> PoolManager:
	
	var manager := PoolManager.new()
	manager.spawn_scene = load( scene_path ) as PackedScene
	
	add_child( manager )
	return manager



@onready var dust_manager := new_manager( "res://Kobold Cave/Particles/Test Dust/test_dust_particles.tscn" )
func spawn_dust( pos: Vector2 ) -> CPUParticles2D:
	
	var spawn := dust_manager.get_item()
	spawn.emitting = true
	spawn.global_position = pos
	
	return spawn
