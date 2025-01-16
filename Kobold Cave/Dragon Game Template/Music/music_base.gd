extends Node
class_name Music
## Abstract base for music scenes
##
## Provides an abstract base for music to play[br]
## Music can be as simple as a single track, or as complex
## as a dynamic score that adds/removes tracks


## just like an audio streamer, if this is true the music plays when ready
@export var auto_play := false

@export_group( "Info" )
## Name of the song
@export_multiline var song_name: String = ""
## Author(s) of the song
@export_multiline var song_author: String = ""


## emitted when the song is played
signal played
## emitted when the song is paused
signal paused
## emitted when the song is unpaused
signal unpaused
## emitted when the music has stopped or faded out
signal stopped


## The "on" volume
const VOLUME_MAX := 0.0
## The "off" volume
const VOLUME_MIN := -60.0


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ): return
	
	if ( auto_play ):
		
		play()


## plays the song from the begining
func play() -> void:
	
	_play()
	played.emit()

## pauses the song
func pause() -> void: 
	
	_pause()
	paused.emit()

## unpauses the song
func unpause() -> void:
	
	_unpause()
	unpaused.emit()

## stops and resets the song
func stop() -> void: 
	
	_stop()
	stopped.emit()


## virtual
func _play() -> void:
	pass

## virtual
func _pause() -> void:
	pass

## virtual
func _unpause() -> void:
	pass

## virtual
func _stop() -> void:
	pass
