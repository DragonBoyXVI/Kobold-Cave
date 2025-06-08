
extends Resource
class_name VoiceProfile
## Provides data for what kind of sound is played for dialouge
##
## ditto


## the audio stream used for this characters voice
@export var stream: AudioStream
## the pitch the audio player node is set to
@export var base_pitch: float = 1.0
