@tool
extends MusicPlayer
class_name MusicPlayerSync
## Class for playing music with [AudioStreamSynchronized]
##
## Provides a few helper functions for playing with synced audio


## the audio stream this passes down to the [AudioStreamPlayer]
@export var stream: AudioStreamSynchronized :
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
		
		if ( stream is not AudioStreamSynchronized ):
			
			const text := "Provided stream must be [AudioStreamSynchronized]!"
			warnings.append( text )
		
		pass
	else:
		
		const text := "Please provide a stream to this instead of the audio player!"
		warnings.append( text )
	
	
	return warnings


## changes the volume of a track over time
func set_track_volume( index: int, volume: float, time: float ) -> void:
	
	# get stream
	var stream_sync := ( audio_player.stream as AudioStreamSynchronized )
	if ( index >= stream_sync.stream_count ): return
	
	# create tween
	var tween := create_tween()
	#stream.set_sync_stream_volume(  )
	tween.tween_method( _tween_vol.bind( index ), stream_sync.get_sync_stream_volume( index ), volume, time )
	
	return 

func _tween_vol( vol: float, index: int ) -> void: 
	
	var stream_sync := ( audio_player.stream as AudioStreamSynchronized )
	stream_sync.set_sync_stream_volume( index, vol )
