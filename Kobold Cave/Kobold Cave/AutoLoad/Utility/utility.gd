
extends Object
class_name KoboldUtility
## class that provides utility funcs
## 
## Provides some useful methods to be used throughout the game


## is true if the game manager is loading a scene
static var in_level_trans := false

## plays a sound with volume adjusted to mimic positional audio[br]
## hoad soundmanager doesn't use positional nodes for audio
static func play_sound_with_location( sound: AudioStream, pos: Vector2, hearable_range := 1000.0 ) -> AudioStreamPlayer:
	
	var ear_position: Vector2 = MainCamera2D.global_position
	
	var sound_range: float = pow( hearable_range, 2.0 )
	var sound_volume: float = 1.0 - ( ear_position.distance_squared_to( pos ) / sound_range )
	sound_volume = clampf( sound_volume, 0.0, 1.0 )
	
	var sound_player: AudioStreamPlayer = SoundManager.play_sound( sound )
	sound_player.volume_linear = sound_volume
	
	return sound_player

static func create_tween_style( myself: Node ) -> Tween:
	
	var tween := myself.create_tween()
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	return tween
