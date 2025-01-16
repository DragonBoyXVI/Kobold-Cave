extends ScalieResource
class_name CameraEffect3D
## Base class for all camera3D effects
##
## This provides a base resource for all camera effects to stem from


func _apply( _cam: Camera3D ) -> void:
	pass

func _unapply( _cam: Camera3D ) -> void:
	pass

func _update( _cam: Camera3D, _delta: float ) -> void:
	pass
