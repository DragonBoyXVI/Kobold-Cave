@tool
extends Node2D
class_name SpikeTrap


const TILE_SIZE: Vector2 = Vector2( 128.0, 128.0 )


@export var tile_length: int = 1 :
	set( value ):
		
		tile_length = maxi( 1, value )
		reposition_sprites()

@export var sprite_spikes: Sprite2D
@export var sprite_ghost: Sprite2D
@export var collison_shape: CollisionShape2D
@export var hurtbox: Hurtbox2D


@export var state: bool:
	set( new_state ):
		
		if ( new_state == state ): return
		state = new_state
		
		if ( Engine.is_editor_hint() ):
			
			if ( new_state ):
				
				spikes_go_up.call_deferred()
			else:
				
				spikes_go_down.call_deferred()
@export var state_flips: bool : 
	set( value ):
		
		state_flips = value
		update_configuration_warnings()
@export var state_timer: Timer :
	set( value ):
		
		state_timer = value
		update_configuration_warnings()

var _tween: Tween


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( state_flips and not state_timer ):
		
		const text := "Connect a timer for state flipping"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	reposition_sprites()
	
	if ( Engine.is_editor_hint() ):
		return
	
	if ( state_flips and state_timer ):
		
		state_timer.timeout.connect( _on_state_timer_timeout )


func _new_tween() -> Tween:
	
	if ( _tween ):
		
		_tween.kill()
	
	var tween := create_tween()
	
	_tween = tween
	return tween

func spikes_go_up() -> void:
	
	hurtbox.enable.call_deferred()
	
	var tween := _new_tween()
	tween.set_parallel()
	
	# send ghost up first
	var ghost_height: float = sprite_ghost.texture.get_height()
	tween.tween_property( sprite_ghost, ^"region_rect:size:y", ghost_height, 0.05 )
	tween.tween_property( sprite_ghost, ^"position:y", -TILE_SIZE.y, 0.05 )
	
	var spike_height: float = sprite_spikes.texture.get_height()
	tween.tween_property( sprite_spikes, ^"region_rect:size:y", spike_height, 0.1 )
	tween.tween_property( sprite_spikes, ^"position:y", -TILE_SIZE.y, 0.1 )

func spikes_go_down() -> void:
	
	hurtbox.disable.call_deferred()
	
	var tween := _new_tween()
	tween.set_parallel()
	
	tween.tween_property( sprite_ghost, ^"region_rect:size:y", 0.0, 0.15 )
	tween.tween_property( sprite_ghost, ^"position:y", 0.0, 0.15 )
	
	tween.tween_property( sprite_spikes, ^"region_rect:size:y", 0.0, 0.1 )
	tween.tween_property( sprite_spikes, ^"position:y", 0.0, 0.1 )



## used to resize and reposition the sprites
func reposition_sprites() -> void:
	
	if ( not sprite_spikes ): return
	if ( not sprite_ghost ): return
	
	var target_rect: Rect2 = Rect2()
	target_rect.position = Vector2( 0.0, -TILE_SIZE.x )
	target_rect.size = Vector2( ( TILE_SIZE.x * tile_length ), TILE_SIZE.y )
	
	var spike_texture: Texture2D = sprite_spikes.texture
	var ghost_texture: Texture2D = sprite_ghost.texture
	
	_reposition( sprite_spikes, spike_texture, target_rect )
	_reposition( sprite_ghost, ghost_texture, target_rect )
	
	# handle collision shape here
	if ( not collison_shape ): return
	
	collison_shape.position = target_rect.get_center()
	
	var shape: RectangleShape2D = collison_shape.shape
	shape.size = target_rect.size

## same as above =3
func _reposition( sprite: Sprite2D, texture: Texture2D, rect: Rect2 ) -> void:
	
	var texture_size: Vector2 = texture.get_size()
	
	var new_scale: Vector2 = Vector2.ONE
	new_scale.x = ( TILE_SIZE.x / texture_size.x )
	new_scale.y = ( TILE_SIZE.y / texture_size.y )
	
	sprite.position = rect.position
	sprite.scale = new_scale
	
	var region_size := Vector2()
	region_size.x = texture_size.x * tile_length
	region_size.y = texture_size.y
	
	sprite.region_rect.size = region_size


func _on_state_timer_timeout() -> void:
	
	if ( state ):
		
		spikes_go_down()
	else:
		
		spikes_go_up()
	
	state = not state


func _on_hurtbox_2d_body_entered( body: Node2D ) -> void:
	
	if ( body is Entity ):
		
		const push_force := 400.0
		var angle: float = rotation - deg_to_rad( 90.0 )
		var push_vector: Vector2 = Vector2.from_angle( angle ) * push_force
		
		body.velocity += push_vector
