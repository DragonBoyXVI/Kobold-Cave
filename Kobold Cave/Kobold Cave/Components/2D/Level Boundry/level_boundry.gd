
extends Area2D
class_name LevelBoundry2D
## when a [Entity] touches this, its out of bounds function
## is run.
## 
## ditto


func _on_body_entered( body: Node2D ) -> void:
	
	if ( body is Entity ):
		var body_entity := body as Entity
		
		body_entity.out_of_bounds()
