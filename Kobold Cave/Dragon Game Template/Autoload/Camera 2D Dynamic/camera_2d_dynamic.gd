extends Camera2D
## the main camera 2D, allows the camera to be globally acessable


## the cameras state machine
@export var state_machine: StateMachine


## a list of currently active camera effects
var active_effects: Dictionary[ int, CameraEffect2D ] = {}
var effect_next_id := 0


func _ready() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated, CONNECT_DEFERRED, Settings.UPDATE.CAMERA )

func _process( delta: float ) -> void:
	
	logic_camera_effects( delta )


## adds an effect to the camera
func add_effect( effect: CameraEffect2D ) -> void:
	
	effect.apply( self )
	active_effects[ effect_next_id ] = effect
	effect_next_id += 1

## removes an effect from the camera, mostly used internally
func remove_effect( index: int ) -> void:
	
	active_effects[ index ].remove( self )
	active_effects.erase( index )

## routine for hanlding camera effects
func logic_camera_effects( delta: float ) -> void:
	
	var effect: CameraEffect2D
	for index: int in active_effects:
		
		effect = active_effects[ index ]
		
		var expired := effect.tick_duration( delta )
		effect.update( self, delta )
		
		if ( expired ):
			
			# deffer as to not change array size while in loop
			remove_effect.call_deferred( index )


## make the camera follow a node
func set_follow_node( node: Node2D ) -> void:
	
	state_machine.change_state( StateCam2DFollowNode.STATE_NAME, {
		StateCam2DFollowNode.ARG_FOLLOW_NODE: node
	} )

## make the camera look at a global coord
func set_follow_coord( global_coord: Vector2 ) -> void:
	
	state_machine.change_state( StateBehaviour.NO_STATE )
	position = global_coord



func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	if ( recived_data.camera_as_physics ):
		
		process_callback = CAMERA2D_PROCESS_PHYSICS
	else:
		
		process_callback = CAMERA2D_PROCESS_IDLE
