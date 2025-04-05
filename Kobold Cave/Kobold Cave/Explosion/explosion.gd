extends Node2D
class_name Explosion
## An explosion in the wolrd
##
## ditto
## WARNING: for some reason, the [Hurtbox2D] spawns
## without an event, even though in the editor it has one.
## if you make the editor resource unique, all its values 
## are set to the defaults instead of the expected. why
# not the init method of damage


@export var hurtbox: Hurtbox2D
@export var push_area: Area2D
@export var animation_player: AnimationPlayer
@export var particles: CPUParticles2D

@export var shapes_to_disable: Array[ CollisionShape2D ]


var _particles_enabled := true

const explode_anim := &"Explode"


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	animation_player.animation_finished.connect( _on_animation_player_animation_finished )
	push_area.body_entered.connect( _on_push_area_body_entered )
	push_area.body_shape_entered.connect( _on_push_area_body_shape_entered )
	particles.finished.connect( _on_particles_finished )
	
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )
	
	
	animation_player.play( explode_anim )


func _trigger_particles() -> void:
	
	if ( _particles_enabled ):
		
		particles.emitting = true

func _disable_shapes() -> void:
	
	for shape: CollisionShape2D in shapes_to_disable:
		
		shape.set_deferred( &"disabled", true )


func _on_push_area_body_entered( body: Node2D ) -> void:
	
	if ( body is not CharacterBody2D ): return
	var entity := body as CharacterBody2D
	
	const push_force: float = 1200.0
	var push_direction: float = global_position.angle_to_point( entity.global_position )
	
	entity.velocity += Vector2.from_angle( push_direction ) * push_force

func _on_push_area_body_shape_entered( body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int ) -> void:
	
	if ( body is TileMapLayer ):
		var body_tilemap := body as TileMapLayer
		
		var cell_coords: Vector2i = body_tilemap.get_coords_for_body_rid( body_rid )
		var cell_data: TileData = body_tilemap.get_cell_tile_data( cell_coords )
		
		if ( not cell_data ): return
		
		const data_breakable := "Breakable"
		if ( cell_data.get_custom_data( data_breakable ) ):
			
			#body_tilemap.erase_cell( cell_coords )
			body_tilemap.set_cells_terrain_connect( [cell_coords], 0, -1 )

func _on_animation_player_animation_finished( anim_name: StringName ) -> void:
	
	if ( anim_name != explode_anim ): return
	if ( _particles_enabled ): return
	
	queue_free()

func _on_particles_finished() -> void:
	
	queue_free()

func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_particles_enabled = recived_data.particles_enabled


# catch the junk data and make it useful data
# despite this function not even being called, and the line
# connecting it is disabled, having this function makes the resource work???
# its not being called, changing this code does nothing.
# dont delete ig???????
func _hurtbox_workaround( damage: Damage ) -> void:
	
	damage.amount = 2
	damage.element = ScalieResource.ELEMENT.FIRE
