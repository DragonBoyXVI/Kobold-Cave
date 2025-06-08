extends Node
## handles some settings changes, like
## fps and window size
##
## Has to be a node, object classes only
## initialize if they are refrenced in a script that gets used


var _window_scaling: int = -1
var _current_language: String


func _init() -> void:
	
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	
	Settings.connect_changed_callback( _on_settings_ticks_changed, 0, Settings.UPDATE.TICK_SPEED )
	Settings.connect_changed_callback( _on_settings_window_changed, 0, Settings.UPDATE.WINDOW_MODE )
	Settings.connect_changed_callback( _on_settings_audio_changed, 0, Settings.UPDATE.AUDIO )
	Settings.connect_changed_callback( _on_settings_translation_changed, 0, Settings.UPDATE.TRANSLATION )


func _on_settings_ticks_changed( new_settings: SettingsFile ) -> void:
	
	if ( new_settings.frame_rate_unlimited ):
		
		Engine.max_fps = 0
	else:
		
		Engine.max_fps = new_settings.frame_rate
	
	Engine.physics_ticks_per_second = new_settings.physics_rate
	
	get_tree().physics_interpolation = new_settings.physics_interpolation
	if ( new_settings.physics_interpolation ):
		
		Engine.physics_jitter_fix = 0.0
	else:
		
		Engine.physics_jitter_fix = 0.5

func _on_settings_window_changed( new_settings: SettingsFile ) -> void:
	
	if ( _window_scaling != new_settings.window_scaling ):
		
		var window := get_window()
		window.content_scale_mode = new_settings.window_scaling as Window.ContentScaleMode
		_window_scaling = new_settings.window_scaling

func _on_settings_translation_changed( new_settings: SettingsFile ) -> void:
	
	if ( _current_language != new_settings.translation ):
		
		_current_language = new_settings.translation
		TranslationServer.set_locale( new_settings.translation )

func _on_settings_audio_changed( new_settings: SettingsFile ) -> void:
	
	var bus_master: int = AudioServer.get_bus_index( &"Master" )
	AudioServer.set_bus_volume_linear( bus_master, new_settings.volume_master )
	
	var bus_music: int = AudioServer.get_bus_index( &"Music" )
	AudioServer.set_bus_volume_linear( bus_music, new_settings.volume_music )
	
	var bus_sfx: int = AudioServer.get_bus_index( &"SFX" )
	AudioServer.set_bus_volume_linear( bus_sfx, new_settings.volume_sfx )
	
	var bus_voice: int = AudioServer.get_bus_index( &"Voice" )
	AudioServer.set_bus_volume_linear( bus_voice, new_settings.volume_voice )
