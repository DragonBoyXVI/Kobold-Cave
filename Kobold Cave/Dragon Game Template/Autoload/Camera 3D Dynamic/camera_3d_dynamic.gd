extends Node3D

# vars
@export var camera: Camera3D
#@export var state_machine: StateMachine

@export var zoom_speed := 10
@export var zoom_min := 5.0
@export var zoom_max := 20.0

var zoom_input: float

var target_rotation := rotation_degrees
var rotation_lerp: float = 0.25


func _process( _delta: float ) -> void:
	var slow := 1.0
	if ( Input.is_action_pressed( "Slow" ) ): slow = 0.05
	
	
	zoom_input = 0
	if ( Input.is_action_just_released( "Zoom In" ) ):
		zoom_input -= 1
	elif ( Input.is_action_just_released( "Zoom Out" ) ):
		zoom_input += 1
	zoom_input *= zoom_speed * slow
	
	pass

func _physics_process( delta: float ) -> void:
	delta = 1.0 / Engine.physics_ticks_per_second
	
	# zoom
	var camera_z := camera.position.z
	
	camera_z += zoom_input * delta
	camera_z = clamp( camera_z, zoom_min, zoom_max )
	
	camera.position.z = camera_z
	
	
	# rotation
	rotation_degrees = lerp( rotation_degrees, target_rotation, rotation_lerp )
	
	pass
