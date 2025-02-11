@tool
extends Hurtbox2D
class_name Explosion


@export var shape: CollisionShape2D

@onready var anim_player := %AnimationPlayer as AnimationPlayer

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ): return
	
	anim_player.play( &"Explode" )


func _disable_shape() -> void:
	
	shape.set_deferred( &"disabled", true )


func _util_child_entered_tree( node: Node ) -> void:
	super( node )
	
	if ( node is CollisionShape2D ):
		
		shape = node


func _on_cpu_particles_dust_finished() -> void:
	
	# oops =3
	if ( Engine.is_editor_hint() ): return
	
	queue_free()
