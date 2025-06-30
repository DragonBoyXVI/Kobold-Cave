extends Node2D
## Creates explosions in the world


const EXPLOSION_SOUND: AudioStream = preload( "uid://b6bja1q8f8v6v" )


const COLLISION_MASK := 0b111
var shape: RID

# preload dont fucjking work for some reason
#const camera_shake: CameraShake2D = preload( "uid://2dryhj15dbtf" )
var camera_shake: CameraShake2D


var personal_sound_effect: AudioStreamPlayer2D

var explosion_queue: Array[ ExplosionParameters ]
const EXPLOSIONS_PER_FRAME: int = 5


func _init() -> void:
	
	camera_shake = CameraShake2D.new()
	camera_shake.shake_strength = 200.0
	camera_shake.duration_max = 0.25
	
	z_index = 2
	auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED

func _ready() -> void:
	
	shape = PhysicsServer2D.circle_shape_create()
	
	personal_sound_effect = AudioStreamPlayer2D.new()
	personal_sound_effect.bus = &"World SFX"
	personal_sound_effect.stream = EXPLOSION_SOUND
	DragonSound.in_world.add_child( personal_sound_effect )

func _exit_tree() -> void:
	
	PhysicsServer2D.free_rid( shape )


## supply a params object to create an explosion
func create_explosion( params: ExplosionParameters ) -> void:
	
	explosion_queue.push_back.call_deferred( params )

func _process_explosion( params: ExplosionParameters ) -> void:
	
	
	params.set_final_radius()
	
	add_explosion_drawing( params )
	PartManager.spawn_particles( params.position, PartManager.EXPLOSION_DUST )
	
	personal_sound_effect.position = params.position
	personal_sound_effect.play()
	
	# shake camera
	var cam_distance := params.position.distance_squared_to( MainCamera2D.position )
	var shake_radius: float = pow( params.final_radius, 2.0 ) * 5.0
	if ( cam_distance < shake_radius ):
		
		var ratio: float = 1.0 - ( cam_distance / shake_radius )
		var effect: CameraShake2D = camera_shake.duplicate()
		effect.shake_strength *= ratio
		effect.duration_max *= ratio
		MainCamera2D.add_effect( effect )
	
	# use a shape cast to detect everything it hits
	var physics_state := get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	query.transform = Transform2D( 0.0, params.position )
	query.collision_mask = COLLISION_MASK
	query.collide_with_areas = true
	query.exclude = params.exclude
	
	query.shape_rid = shape
	PhysicsServer2D.shape_set_data( shape, params.final_radius )
	
	# prob more performant to set terrain all at once
	#var tile_cache: Array[ Vector2i ] = []
	
	var result: Array[ Dictionary ] = physics_state.intersect_shape( query )
	for item: Dictionary in result:
		var collider: Node2D = item[ "collider" ]
		
		if ( collider is CharacterBody2D ):
			
			var direction: Vector2 = ( collider.position - params.position ).normalized()
			collider.velocity += direction * params.push
		elif( collider is ObjHitbox2D ):
			
			collider.hit( params.damage.duplicate() )
		elif( collider is TileMapLayer ):
			
			var tile_rid: RID = item[ "rid" ]
			var tile_coords: Vector2i = collider.get_coords_for_body_rid( tile_rid )
			var tile_data: TileData = collider.get_cell_tile_data( tile_coords )
			
			if ( tile_data ):
				if ( tile_data.has_custom_data( "Breakable" ) ):
					if ( tile_data.get_custom_data( "Breakable" ) ):
						
						if ( collider.tile_set.get_terrain_sets_count() > 0 ):
							
							collider.set_cells_terrain_connect( [ tile_coords ], 0, -1 )
						else:
							
							collider.set_cell( tile_coords )


class DrawExplosion:
	extends RefCounted
	
	var current_time: float = 0.0
	var max_time: float = 0.15
	
	var radius: float = 0.0
	var position: Vector2 = Vector2.ZERO

var things_to_draw: Dictionary[ int, DrawExplosion ] = {}
var next_draw_id: int = 0
## used internally to draw the explosion area, does not create an explosion
func add_explosion_drawing( params: ExplosionParameters ) -> void:
	
	var new := DrawExplosion.new()
	new.radius = params.final_radius
	new.position = params.position
	
	things_to_draw[ next_draw_id ] = new
	next_draw_id += 1

func _process( delta: float ) -> void:
	
	if ( things_to_draw.size() > 0 ):
		
		queue_redraw()
		for id: int in things_to_draw:
			var thing: DrawExplosion = things_to_draw[ id ]
			
			thing.current_time += delta
			if ( thing.current_time > thing.max_time ):
				
				_free_drawing.call_deferred( id )

func _physics_process( _delta: float) -> void:
	
	for index: int in mini( EXPLOSIONS_PER_FRAME, explosion_queue.size() ):
		
		var params: ExplosionParameters = explosion_queue[ index ]
		_process_explosion( params )
		
		explosion_queue.erase.call_deferred( params )

func _draw() -> void:
	
	for id: int in things_to_draw:
		var draw_item: DrawExplosion = things_to_draw[ id ]
		
		var opacity: float = 1.0 - ( draw_item.current_time / draw_item.max_time )
		opacity = maxf( 0.0, opacity )
		draw_circle( draw_item.position, draw_item.radius, Color( "Red", opacity ), true )

func _free_drawing( id: int ) -> void:
	
	things_to_draw.erase( id )
