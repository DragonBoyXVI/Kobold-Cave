extends Camera2D
## the main camera 2D, allows the camera to be globally acessable


## the cameras state machine
@onready var state_machine := $StateMachine as StateMachine


## a list of currently active camera effects
var active_effects: Dictionary = {}
var effect_next_id := 0


func _ready() -> void:
	
	Settings.loaded.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated_camera.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated.connect( _on_settings_updated, CONNECT_DEFERRED )
	
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )

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
		
		effect = active_effects[ index ] as CameraEffect2D
		
		var expired := effect.tick_duration( delta )
		effect.update( self, delta )
		
		if ( expired ):
			
			# deffer as to not change array size while in loop
			remove_effect.call_deferred( index )


func set_zoom_tween( new_zoom: Vector2, time: float = 1.25 ) -> void:
	
	var tween := create_tween()
	tween.set_ignore_time_scale()
	
	tween.tween_property( self, ^"zoom", new_zoom, time )


## make the camera follow a node
func set_follow_node( node: Node2D ) -> void:
	
	const state_name := &"FollowNode"
	const arg_node := &"Node"
	print( { arg_node: node } )
	state_machine.change_state( state_name, { arg_node: node } )

## make the camera look at a global coord
func set_follow_coord( global_coord: Vector2 ) -> void:
	
	const state_name := &"NoBehaviour"
	state_machine.change_state( state_name )
	
	position = global_coord


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	if ( recived_data.camera_as_physics ):
		
		process_callback = CAMERA2D_PROCESS_PHYSICS
	else:
		
		process_callback = CAMERA2D_PROCESS_IDLE
