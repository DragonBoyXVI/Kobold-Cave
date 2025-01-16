extends Node3D

@export var offset := Vector3( 10, 10, 5 )
var start := position

var timer := 0.0
func _process( delta: float ) -> void:
	timer += delta
	
	position = start + ( offset * sin( timer ) )
	
	pass
