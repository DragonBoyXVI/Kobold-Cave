@tool
extends PlayerState
class_name PlayerClimbToLedge
## Moves the player to the ledge instead of snapping to it
##
## ditto

const STATE_NAME := &"PlayerClimbToLedge"
const ARG_GRAB_INFO := &"Grab Info"


@export var ledge_grabber: LedgeGrabDetector
@export var ref_marker: Marker2D
@export var player_shape: CollisionShape2D


## ensure we do not exit this state while using "await"
var _exit_valid: bool = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not ledge_grabber ):
		
		const text := "GRABBER NEEDED AAAAAAAA"
		warnings.append( text )
	
	if ( not player_shape ):
		
		const text := "Provide the player shape to offset the player correctly"
		warnings.append( text )
	
	if ( not ref_marker ):
		
		const text := "Ledge grabbing wont work without a ref marker!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	ledge_grabber.found_grab_ledge.connect( _on_ledge_grabber_found_ledge )


var movement_tween: Tween
func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	var grab_info: LedgeGrabInfo = args[ ARG_GRAB_INFO ]
	
	player.velocity = Vector2.ZERO
	if ( grab_info.grab_to_the_right ):
		
		model.scale.x = 1.0
	else:
		
		model.scale.x = -1.0
	
	# play a ledge scrable anim here
	
	# raycast to find the edge of the tile
	if ( not Engine.is_in_physics_frame() ):
		await get_tree().physics_frame
	
	var ray_query := PhysicsRayQueryParameters2D.create( ref_marker.global_position, grab_info.grab_position, 0b1 )
	var direct_state := player.get_world_2d().direct_space_state
	var ray_result: Dictionary = direct_state.intersect_ray( ray_query )
	if ( ray_result.is_empty() ):
		
		request_state( PlayerAir.STATE_NAME, {
			PlayerAir.ARG_GRAB_TIME: 2.0
		} )
		print( "lmao you missed" )
		return
	
	# get the position of the player smushed up to the wall
	var wall_position: Vector2 = ray_result[ "position" ]
	var player_size: Rect2 = player_shape.shape.get_rect()
	const size_offset: float = 0.5
	
	var new_position: Vector2 = Vector2( wall_position.x, grab_info.grab_position.y )
	new_position.y += size_offset * player_size.size.y
	if ( grab_info.grab_to_the_right ):
		
		new_position.x -= 1.0 # buffer just in case
		new_position.x -= player_size.size.x / 2.0
	else:
		
		new_position.x += 1.0
		new_position.x += player_size.size.x / 2.0
	
	# tween the player to tha position
	movement_tween = player.create_tween()
	movement_tween.set_process_mode( Tween.TWEEN_PROCESS_PHYSICS )
	movement_tween.set_ease( Tween.EASE_OUT )
	movement_tween.set_trans( Tween.TRANS_CIRC )
	
	movement_tween.tween_property( player, ^"position", new_position, 0.2 )
	
	movement_tween.finished.connect( _on_move_tween_finished.bind( grab_info ) )

func _leave() -> void:
	
	if ( movement_tween ):
		
		if ( movement_tween.is_running() ):
			
			movement_tween.kill()
		
		movement_tween = null


func _physics_process( _delta: float ) -> void:
	
	if ( player.velocity.length_squared() > 0.0 ):
		
		request_state( PlayerAir.STATE_NAME )

func _unhandled_input( event: InputEvent ) -> void:
	super( event )
	var window := get_window()
	if ( window.is_input_handled() ): return
	
	if ( event.is_action_pressed( &"Jump" ) ):
		
		player.logic_apply_jump(  )
		#request_state( PlayerAir.STATE_NAME )
		
		window.set_input_as_handled()
		return


func _change_is_valid( state: StateBehaviour ) -> bool:
	if ( not super( state ) ): return false
	
	return _exit_valid


func _on_ledge_grabber_found_ledge( grab_info: LedgeGrabInfo ) -> void:
	
	if ( not can_process() ):
		
		request_state( STATE_NAME, {
			ARG_GRAB_INFO: grab_info
		} )

func _on_move_tween_finished( grab_info: LedgeGrabInfo ) -> void:
	
	request_state( PlayerGrabbedLedge.STATE_NAME,{
			ARG_GRAB_INFO: grab_info
		} )
