@tool
extends Node2D


var initial_position := position
@export var offset := Vector2( 300, 300 )


func _ready() -> void:
	if ( Engine.is_editor_hint() ): return
	
	MainCamera2D.follow_this_node( self )

var time := 0.0
func _physics_process( delta: float ) -> void:
	
	time += delta
	position = initial_position + ( offset * sin( time ) )
	
	pass
