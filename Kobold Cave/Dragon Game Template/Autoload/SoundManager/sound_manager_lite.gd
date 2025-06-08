
extends Object
class_name DragonSound
## Manager that handles playing sounds
##
## ditto


const NodeManager := preload( "uid://durb8j10032sp" )


## all sounds played in the game world,
## gets paused with the tree
static var in_world: NodeManager
## all sounds played for the ui,
## ignores tree paused
static var gui: NodeManager
## all sounds related to music,
## it pause state is toggled by [Settings]
static var music: NodeManager


static func _static_init() -> void:
	
	Settings.connect_changed_callback( _on_settings_updated )
	
	# you made an autoload with extra steps, good job girl
	var tree: SceneTree = Engine.get_main_loop()
	#await tree.physics_frame
	
	in_world = NodeManager.new()
	in_world.default_bus = &"World SFX"
	tree.root.add_child( in_world )
	
	gui = NodeManager.new()
	gui.default_bus = &"SFX"
	gui.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child( gui )
	
	music = NodeManager.new()
	music.default_bus = &"Music"
	tree.root.add_child( music )


static func _on_settings_updated( new_file: SettingsFile ) -> void:
	
	if ( new_file.pause_music_when_paused ):
		
		music.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		
		music.process_mode = Node.PROCESS_MODE_ALWAYS
