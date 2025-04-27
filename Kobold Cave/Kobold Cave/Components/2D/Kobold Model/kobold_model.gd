@tool
extends DragonModel2D
class_name KoboldModel2D


@export var movie_writer_anim: StringName = &"" :
	set( new ):
		
		movie_writer_anim = new
		update_configuration_warnings()
@export var footstep_mark: Marker2D:
	set( new ):
		
		footstep_mark = new
		update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if ( not footstep_mark ):
		
		const text := "Footstep mark is needed to play footsteps"
		warnings.append( text )
	
	if ( not movie_writer_anim.is_empty() and animation_player ):
		
		if ( not animation_player.has_animation( movie_writer_anim ) ):
			
			const text := "Animation does not exist"
			warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ): return
	
	if ( not movie_writer_anim.is_empty() ):
		
		animation_player.play( movie_writer_anim )
		animation_player.movie_quit_on_finish = true

func play_footstep_sound() -> void:
	
	KoboldRadio.play_footstep.emit( footstep_mark.global_position )
