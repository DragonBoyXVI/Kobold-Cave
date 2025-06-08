
extends Object
class_name Settings
## holds a [SettingsFile] resource 
##
## So, because of the way this scripts are handled
## internally, they aren't loaded unless a script that
## uses them is run.[br]
## [Settings] is basically always going to be used,
## so rn it acts as the entry points for most other 
## scripts that needs to be active from the start of
## the game


const FILE_PATH := "user://settings.tres"


enum UPDATE {
	
	TICK_SPEED = 1<<0,
	WINDOW_MODE = 1<<1,
	AUDIO = 1<<2,
	TRANSLATION = 1<<3,
	CAMERA = 1<<4,
	
	ALL = 0b11111,
}
## returns UPDATE enum names for editor usage
static func get_update_flags() -> PackedStringArray:
	
	var flags := UPDATE.keys()
	flags.pop_back()
	
	return flags


## the current settings data
static var current_file: SettingsFile


static func _static_init() -> void:
	
	SettingsHandler.hookup_to_settings()
	DragonPauser.hookup_to_settings()
	
	load_file()


## loads a [SettingsFile] from a path
static func load_file( file_path := FILE_PATH ) -> void:
	
	var loaded_file: Resource
	if ( FileAccess.file_exists( file_path ) ):
		
		loaded_file = load( file_path )
	
	if ( loaded_file is SettingsFile ):
		
		current_file = loaded_file
	else:
		
		current_file = SettingsFile.new()
	
	# done so it works at the start of the game, 
	# when the radio doesn't exist
	notify_settings_changed.call_deferred()

## saves the file to disc
static func save_file( file_path := FILE_PATH ) -> void:
	
	ResourceSaver.save( current_file, file_path )


## used to notify the game to update settings
static func notify_settings_changed( flags: int = UPDATE.ALL ) -> void:
	if ( not current_file ): return
	
	if ( flags == UPDATE.ALL ):
		
		DragonRadio.settings_changed.emit( current_file )
		return
	
	if ( flags & UPDATE.TICK_SPEED ):
		
		DragonRadio.settings_changed_ticks.emit( current_file )
	if ( flags & UPDATE.WINDOW_MODE ):
		
		DragonRadio.settings_changed_window.emit( current_file )
	if ( flags & UPDATE.AUDIO ):
		
		DragonRadio.settings_changed_audio.emit( current_file )
	if ( flags & UPDATE.TRANSLATION ):
		
		DragonRadio.settings_changed_translation.emit( current_file )
	if ( flags & UPDATE.CAMERA ):
		
		DragonRadio.settings_changed_camera.emit( current_file )

## shortcut for connecting a settings update callback
## and running it.[br]
## Callback flags is the usual [ConnectFlags][br]
## Settings flags describes what kind of update this wants,
## though all callbacks are connected to the generic "chnaged"
## signal reguardless
@warning_ignore("int_as_enum_without_match")
static func connect_changed_callback( callback: Callable, callback_flags: int = 0, settings_flags: int = 0 ) -> void:
	
	# done to ensure this can be run when autoloads arent ready
	if ( not DragonRadio or not DragonRadio.is_node_ready() ):
		await Engine.get_main_loop().physics_frame
	
	if ( settings_flags & UPDATE.TICK_SPEED ):
		
		DragonRadio.settings_changed_ticks.connect( callback, callback_flags )
	if ( settings_flags & UPDATE.WINDOW_MODE ):
		
		DragonRadio.settings_changed_window.connect( callback, callback_flags )
	if ( settings_flags & UPDATE.AUDIO ):
		
		DragonRadio.settings_changed_audio.connect( callback, callback_flags )
	if ( settings_flags & UPDATE.TRANSLATION ):
		
		DragonRadio.settings_changed_translation.connect( callback, callback_flags )
	if ( settings_flags & UPDATE.CAMERA ):
		
		DragonRadio.settings_changed_camera.connect( callback, callback_flags )
	
	DragonRadio.settings_changed.connect( callback, callback_flags )
	
	if ( current_file ):
		
		callback.call_deferred( current_file )
