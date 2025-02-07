
extends CharacterBody2D
class_name Bomb
## a bomb that explodes
##
## woaoaoaw, pip ebomb, so cool....


func logic_gravity( delta: float ) -> void:
	
	const gravity := 2000.0
	
	velocity.y += gravity * delta


func explode() -> void:
	
	pass


func _on_hitbox_2d_recived_event( event: HurtboxEvent ) -> void:
	
	if ( event is BaseDamage ):
		
		explode()
