@tool
extends PlayerState
class_name PlayerTrans
## Play an anim tehn go to the next state
##
## useful for code, yay

const STATE_NAME := &"PlayerTrans"


## the animation player from the model
var anim_player: AnimationPlayer


## the animation we want to play
var anim_to_play: StringName
## the state to enter when done
var exit_state: StringName


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	
	return warnings

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		
		return
	
	anim_player = model.animation_player
	anim_player.animation_finished.connect( _on_animation_player_finished )


func _enter( _args: Array = [] ) -> void:
	
	anim_player.play( anim_to_play )

func _physics_process( delta: float ) -> void:
	
	player.routine_airborne( delta, Vector2.ZERO )
	player.move_and_slide()


func _on_animation_player_finished( _anim_name: StringName ) -> void:
	if ( not can_process() ): return
	
	request_state( exit_state )
