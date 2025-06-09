extends Node2D


class PartPool:
	extends Node2D
	
	var options: ParticleOptions
	
	var _avaliable: Array[ CPUParticles2D ] = []
	
	
	func init_populace() -> void:
		
		for _i: int in options.initial_scene_count:
			
			make_item()
	
	
	func make_item() -> void:
		
		var new_item: CPUParticles2D = options.packed_scene.instantiate(  )
		new_item.hide()
		new_item.process_mode = Node.PROCESS_MODE_DISABLED
		new_item.finished.connect( _on_child_finished.bind( new_item ), CONNECT_DEFERRED )
		
		add_child( new_item )
		_avaliable.append( new_item )
	
	func get_item() -> CPUParticles2D:
		
		if ( _avaliable.size() > 0 ):
			
			var item: CPUParticles2D = _avaliable.pop_back()
			return item
		
		make_item()
		return _avaliable.pop_back()
	
	
	func _on_child_finished( child: CPUParticles2D ) -> void:
		
		child.restart()
		child.hide()
		child.process_mode = Node.PROCESS_MODE_DISABLED
		
		_avaliable.append( child )


const SMALL_DUST: ParticleOptions = preload( "uid://0chm1vymshi" )
const EXPLOSION_DUST: ParticleOptions = preload( "uid://kaquuk3542fp" )


var _particles_enabled: bool = true


var _pool_cache: Dictionary[ ParticleOptions, PartPool ] = {}


func _init() -> void:
	
	z_index = 6

func _ready() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )
	
	create_pool( SMALL_DUST )
	create_pool( EXPLOSION_DUST )


func create_pool( options: ParticleOptions ) -> void:
	
	var new_pool := PartPool.new()
	new_pool.options = options
	add_child( new_pool )
	
	new_pool.init_populace()
	
	_pool_cache[ options ] = new_pool

func spawn_particles( pos: Vector2, key: ParticleOptions ) -> void:
	if ( not _particles_enabled ): return
	
	
	if ( _pool_cache.has( key ) ):
		
		var pool := _pool_cache[ key ]
		var item := pool.get_item()
		item.position = pos
		item.emitting = true
		item.process_mode = Node.PROCESS_MODE_INHERIT
		item.show()
	else:
		
		create_pool( key )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_particles_enabled = recived_data.particles_enabled
