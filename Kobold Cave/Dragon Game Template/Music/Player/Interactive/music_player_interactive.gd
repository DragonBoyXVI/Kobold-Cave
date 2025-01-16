@tool
extends MusicPlayer
class_name MusicPlayerInteractive
## Provides functions for an interactive music player
##
## Gives you soem extra helper functions for using interactive music


## the audio stream this passes down to the [AudioStreamPlayer]
@export var stream: AudioStreamInteractive :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		stream = value
		if ( audio_player ):
			
			audio_player.stream = stream


func _ready() -> void:
	
	if ( audio_player ):
		
		audio_player.stream = stream
	
	super()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	
	if ( stream ):
		
		if ( stream is not AudioStreamInteractive ):
			
			const text := "Provided stream must be [AudioStreamInteractive]!"
			warnings.append( text )
		
		pass
	else:
		
		const text := "Please provide a stream to this instead of the audio player!"
		warnings.append( text )
	
	
	return warnings


func switch_to_clip_by_name( clip_name: StringName ) -> void:
	
	var stream_interact := ( audio_player.get_stream_playback() as AudioStreamPlaybackInteractive )
	stream_interact.switch_to_clip_by_name( clip_name )

func switch_to_clip( clip_index: int ) -> void:
	
	var stream_interact := ( audio_player.get_stream_playback() as AudioStreamPlaybackInteractive )
	stream_interact.switch_to_clip( clip_index )
