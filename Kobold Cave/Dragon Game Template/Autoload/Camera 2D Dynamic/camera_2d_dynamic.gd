extends Camera2D
## the main camera 2D, allows the camera to be globally acessable


## the cameras listiner
@onready var listiner := $AudioListener2D as AudioListener2D
## the cameras state machine
@onready var state_machine := $StateMachine as StateMachine


## increases the distance the camera travels
var speed_multiplier: float = 5.0
## how fast the camera moves when lerping
var lerp_speed: float = 0.25


## a list of currently active camera effects
var active_effects: Array[ CameraEffect2D ] = []


## changed by settings to weaken camera shake
var shake_strength: float = 1.0


func _ready() -> void:
	
	Settings.loaded.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated_camera.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated.connect( _on_settings_updated, CONNECT_DEFERRED )
	
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )


## adds an effect to the camera
func add_effect( effect: CameraEffect2D ) -> void:
	
	effect.apply( self )
	active_effects.append( effect )

## removes an effect from the camera, mostly used internally
func remove_effect( index: int ) -> void:
	
	active_effects[ index ].remove( self )
	active_effects.pop_at( index )


## routine for hanlding camera effects
func logic_camera_effects( delta: float ) -> void:
	
	var effect: CameraEffect2D
	for index: int in active_effects.size():
		
		effect = active_effects[ index ]
		
		var expired := effect.tick_duration( delta )
		effect.update( self, delta )
		
		if ( expired ):
			
			# deffer as to not change array size while in loop
			remove_effect.call_deferred( index )

## Moves the camera toward a point
func logic_move_toward( point: Vector2, delta: float ) -> void:
	
	delta *= speed_multiplier
	if ( delta > 1.0 ):
		global_position = point
		return
	
	position = position.lerp( point, delta )


## standard camera routine
func routine_camera( point: Vector2, delta: float ) -> void:
	
	logic_move_toward( point, delta )
	logic_camera_effects( delta )


@onready var look_point := $StateMachine/FollowPoint as StateBehaviour
## Sets the camera to the idle state and makes it look at a point
func set_state_look_at_point( point: Vector2 ) -> void:
	
	state_machine.change_state( look_point.name )
	look_point.point = point

@onready var follow_state := $StateMachine/FollowNode as StateBehaviour
## Sets the camera to follow a node
func set_state_follow_node( node: Node2D ) -> void:
	
	state_machine.change_state( follow_state.name )
	follow_state.node_to_follow = node


@onready var manual_debug := $StateMachine/ManualDebug as StateBehaviour
## free came mode, not meant for gameplay
func set_state_free_cam() -> void:
	
	state_machine.change_state( manual_debug.name )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	shake_strength = recived_data.camera_shake_strength
	
	if ( recived_data.camera_as_physics ):
		
		process_callback = CAMERA2D_PROCESS_PHYSICS
	else:
		
		process_callback = CAMERA2D_PROCESS_IDLE
