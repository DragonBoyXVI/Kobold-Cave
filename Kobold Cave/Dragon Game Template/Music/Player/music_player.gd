@tool
extends Music
class_name MusicPlayer
## A straight forward music player
##
## A simple music player that places most of the workload on the
## stream player


## the audio stream player
@export var audio_player: AudioStreamPlayer : 
	set( new_player ):
		update_configuration_warnings.call_deferred()
		
		if ( new_player ):
			
			new_player.bus = BUS_MUSIC
		
		audio_player = new_player
## how long it takes for the song to fade out when stop is called
@export var fade_out_time: float = 1.25


const BUS_MUSIC := &"Music"


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not audio_player ):
		
		const text := "Please provide an audio player to work with!"
		warnings.append( text )
	
	return warnings


func stop() -> void:
	
	await _stop()
	stopped.emit()


func _play() -> void:
	
	audio_player.play()

func _pause() -> void:
	
	audio_player.stream_paused = true

func _unpause() -> void:
	
	audio_player.stream_paused = false

func _stop() -> void:
	
	# tween volume
	var tween := create_tween()
	tween.tween_property( audio_player, ^"volume_db", VOLUME_MIN, fade_out_time )
	
	await tween.finished
	
	# stop music
	audio_player.stop()
