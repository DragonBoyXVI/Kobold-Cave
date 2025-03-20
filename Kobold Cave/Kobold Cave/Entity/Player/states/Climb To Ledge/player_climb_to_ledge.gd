@tool
extends PlayerState
class_name PlayerClimbToLedge
## Moves the player to the ledge instead of snapping to it
##
## ditto

const STATE_NAME := &"PlayerClimbToLedge"

const TILE_SIZE := Vector2( 128.0, 128.0 )
const ARG_GRAB_POSITION := &"Grab Position"
const ARG_GRAB_RIGHT := &"Grab Right"


@export var ledge_grabber: LedgeGrabDetector
@export var player_shape: CollisionShape2D


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not ledge_grabber ):
		
		const text := "GRABBER NEEDED AAAAAAAA"
		warnings.append( text )
	
	if ( not player_shape ):
		
		const text := "Provide the player shape to offset the player correctly"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	ledge_grabber.found_grab_ledge.connect( _on_ledge_grabber_found_ledge )


var movement_tween: Tween
func _enter( args: Dictionary[ StringName, Variant ] ) -> void:
	
	var grabbed_position: Vector2 = args[ ARG_GRAB_POSITION ]
	var grabbed_right: bool = args[ ARG_GRAB_RIGHT ]
	
	
	player.velocity = Vector2.ZERO
	if ( grabbed_right ):
		
		model.scale.x = 1.0
	else:
		
		model.scale.x = -1.0
	
	# play a ledge scrable anim here
	
	var player_size: Rect2 = player_shape.shape.get_rect()
	const size_offset: float = 0.2
	
	var new_position: Vector2 = grabbed_position
	new_position.y += TILE_SIZE.y / 2.0
	new_position.y -= size_offset * player_size.size.y
	if ( grabbed_right ):
		
		new_position.x -= 1.0 # buffer just in case
		new_position.x -= TILE_SIZE.x / 2.0
		new_position.x -= player_size.size.x / 2.0
	else:
		
		new_position.x += 1.0
		new_position.x += TILE_SIZE.x / 2.0
		new_position.x += player_size.size.x / 2.0
	
	movement_tween = player.create_tween()
	movement_tween.set_process_mode( Tween.TWEEN_PROCESS_PHYSICS )
	movement_tween.set_ease( Tween.EASE_OUT )
	movement_tween.set_trans( Tween.TRANS_CIRC )
	
	movement_tween.tween_property( player, ^"position", new_position, 0.2 )
	
	movement_tween.finished.connect( _on_move_tween_finished.bind( grabbed_position, grabbed_right ), CONNECT_DEFERRED )

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


func _on_ledge_grabber_found_ledge( ledge_position: Vector2, ledge_right_side: bool ) -> void:
	
	if ( not can_process() ):
		
		request_state( STATE_NAME, {
			ARG_GRAB_POSITION: ledge_position,
			ARG_GRAB_RIGHT: ledge_right_side
		} )

func _on_move_tween_finished( ledge_position: Vector2, ledge_side: bool ) -> void:
	
	request_state( PlayerGrabbedLedge.STATE_NAME,{
			ARG_GRAB_POSITION: ledge_position,
			ARG_GRAB_RIGHT: ledge_side
		} )
