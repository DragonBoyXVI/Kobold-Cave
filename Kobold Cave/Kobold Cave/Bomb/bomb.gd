
extends CharacterBody2D
class_name Bomb
## a bomb that explodes
##
## woaoaoaw, pip ebomb, so cool....


func logic_gravity( delta: float ) -> void:
	
	const gravity := 2000.0
	
	velocity.y += gravity * delta


func explode() -> void:
	
	const explosion_scene := preload( "res://Kobold Cave/Explosion/explosion.tscn" )
	
	var explosion := explosion_scene.instantiate() as Explosion
	explosion.global_position = global_position
	
	get_tree().current_scene.add_child.call_deferred( explosion )
	queue_free()


func _on_hitbox_2d_recived_event( event: HurtboxEvent ) -> void:
	
	if ( event is BaseDamage ):
		
		explode()
