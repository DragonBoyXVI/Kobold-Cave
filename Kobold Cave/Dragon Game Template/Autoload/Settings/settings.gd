extends Node
## Manages settings data
##
## Manages settings and makes them globally acessable


## Emited when settings are to be applied
signal updated( recived_data: SettingsFile )
## Emited when the engine tick rate changes
signal updated_tick_speed( recived_data: SettingsFile )
## Emited when the window scaling mode changed
signal updated_window_mode( recived_data: SettingsFile )
## Emited when audio settings are updated
signal updated_audio( recived_data: SettingsFile )
## Emited when translation is changed
signal updated_translation( recived_data: SettingsFile )
## Emitted when camera settings are changed
signal updated_camera( recived_data: SettingsFile )

## Emited when settings are loaded
signal loaded( loaded_data: SettingsFile )
## Emited when settings are saved
signal saved( saved_data: SettingsFile )

## Emitted when setting widgets need to be disabled
signal widget_enabled( property: StringName, enable: bool )


## a copy of the default settings
var defaults := SettingsFile.new()

## the currently loaded settings
var data: SettingsFile

## file path use for saving/loading
const file_path := "user://settings.tres"


func _ready() -> void:
	
	DragonRadio.tree_quited.connect( save_data )
	
	# some signals =3
	updated.connect( _update_engine_fps )
	updated_tick_speed.connect( _update_engine_fps )
	
	updated.connect( _update_window_scaling )
	updated_window_mode.connect( _update_window_scaling )
	
	updated.connect( _update_audio_settings )
	updated_audio.connect( _update_audio_settings )
	
	updated.connect( _update_translation )
	updated_translation.connect( _update_translation )
	
	# load and apply data
	await get_tree().process_frame
	
	load_data()
	update_all()
	
	pass


## sends update signal
func update_all() -> void:
	updated.emit( data )

## sends engine update
func update_tick_speed() -> void:
	updated_tick_speed.emit( data )

## sends window update
func update_window_mode() -> void:
	updated_window_mode.emit( data )

## sends audio update
func update_audio() -> void:
	updated_audio.emit( data )

## sends translation update
func update_translation() -> void:
	updated_translation.emit( data )

## sends camera update
func update_camera() -> void:
	updated_camera.emit( data )


## save the currently held data, if none exists, a new one is created and that is saved.
func save_data() -> void:
	
	# save out file
	ResourceSaver.save( data, file_path )
	print( "Settings: Saved data to ", file_path )
	
	# saving done
	saved.emit( data )
	
	pass

## looks for previously saved data, if none is found, new data is created.
func load_data() -> void:
	
	# check that file exists
	if ( not FileAccess.file_exists( file_path ) ):
		
		# make new data
		data = SettingsFile.new()
		print( "Settings: No file found, new one made." )
		
		pass
	# load that file
	else: 
		
		data = ( load( file_path ) as SettingsFile )
	
	# loaded settings done
	loaded.emit( data )


## emits a signal that enables or disables widgets that edit a setting
func enable_setting_widgets( property: StringName, enable: bool ) -> void:
	
	widget_enabled.emit( property, enable )


# some updates we have to handle here

func _update_engine_fps( recived_data: SettingsFile ) -> void:
	
	if ( recived_data.frame_rate_unlimited ):
		
		Engine.max_fps = 0
		enable_setting_widgets( &"frame_rate", false )
	else:
		
		Engine.max_fps = recived_data.frame_rate
		enable_setting_widgets( &"frame_rate", true )
	
	get_tree().set_deferred( &"physics_interpolation", recived_data.physics_interpolation_enabled )
	Engine.physics_ticks_per_second = recived_data.physics_rate

func _update_window_scaling( recived_data: SettingsFile ) -> void:
	
	@warning_ignore("int_as_enum_without_cast")
	get_window().content_scale_mode = recived_data.window_scaling
	
	pass

var audio_bus_master := AudioServer.get_bus_index( "Master" )
var audio_bus_music := AudioServer.get_bus_index( "Music" )
var audio_bus_voice := AudioServer.get_bus_index( "Voice" )
var audio_bus_sfx := AudioServer.get_bus_index( "SFX" )
func _update_audio_settings( recived_data: SettingsFile ) -> void:
	
	var volume_master := linear_to_db( recived_data.volume_master )
	AudioServer.set_bus_volume_db( audio_bus_master, volume_master )
	
	var volume_music := linear_to_db( recived_data.volume_music )
	AudioServer.set_bus_volume_db( audio_bus_music, volume_music )
	
	var volume_voice := linear_to_db( recived_data.volume_voice )
	AudioServer.set_bus_volume_db( audio_bus_voice, volume_voice)
	
	var volume_sfx := linear_to_db( recived_data.volume_sfx )
	AudioServer.set_bus_volume_db( audio_bus_sfx, volume_sfx )
	
	pass

func _update_translation( recived_data: SettingsFile ) -> void:
	const locales: PackedStringArray = [ "en", "es", "ja", "zh", "ru", "de", "pt" ]
	
	if ( recived_data.translation < locales.size() ):
		TranslationServer.set_locale( locales[ recived_data.translation ] )
	
	pass
