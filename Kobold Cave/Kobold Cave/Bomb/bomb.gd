
extends CharacterBody2D
class_name Bomb
## a bomb that explodes
##
## woaoaoaw, pip ebomb, so cool....


@export var hitbox: Hitbox2D


func logic_gravity( delta: float ) -> void:
	
	const gravity := 2000.0
	
	velocity.y += gravity * delta


func explode() -> void:
	
	var params := ExplosionParameters.new()
	params.radius = 160.0
	params.position = global_position
	params.exclude = [ get_rid(), hitbox.get_rid() ]
	#ExplosionServer.create_explosion( params )
	# infinite loop, created explosion hits the bomb
	get_tree().physics_frame.connect( ExplosionServer.create_explosion.bind( params ), CONNECT_REFERENCE_COUNTED | CONNECT_ONE_SHOT )
	
	queue_free()


func _on_hitbox_2d_recived_event( event: HurtboxEvent ) -> void:
	
	if ( event is Damage ):
		
		explode()
