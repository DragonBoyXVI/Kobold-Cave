@tool
extends CameraEffect2D
class_name CameraPush2D
## Pushes the camera in a direction.
##
## This effect will push the camera in a direction.


enum PUSH_TYPE {
	ANIMATED, ## use a curve and change offset
	ACTUAL ## move the camera 
}


@export_group( "Push", "push_" )
## the direction the camera is to be pushed
@export var push_direction: Vector2

## the curve to use
@export var push_curve: Curve


func _init() -> void:
	
	duration_mode = DURATION_MODE.LIMITED
	
	# default curve
	if ( not push_curve ):
		
		push_curve = Curve.new()
		push_curve.add_point( Vector2.ZERO )
		push_curve.add_point( Vector2( 0.25, 1.0 ) )
		push_curve.add_point( Vector2( 1.0, 0.0 ) )

func _validate_property( property: Dictionary ) -> void:
	
	if ( property.name == &"duration_mode" ):
		
		property.usage |= PROPERTY_USAGE_READ_ONLY


func _remove( cam: Camera2D ) -> void:
	
	cam.create_tween().tween_property( cam, ^"offset", Vector2.ZERO, 0.25 )

func _update( cam: Camera2D, _delta: float ) -> void:
	
	# curve factor
	var curve_factor := 1.0
	if ( push_curve ):
		
		curve_factor = push_curve.sample_baked( duration_percent )
	
	# push
	var push_vector := push_direction * curve_factor
	cam.offset = push_vector
