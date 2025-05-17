
extends Object
class_name SaveGameManager
## Manages your save game data and all that
##
## ditto


## default save file location
const SAVE_FILE_PATH: String = "user://kc_save.tres"


## current save file
static var current_file: SaveFile


static func _static_init() -> void:
	
	print( "i ran" )
	
	if ( Engine.is_editor_hint() ):
		return
	
	await Engine.get_main_loop().physics_frame
	if ( not KoboldRadio.is_node_ready() ):
		await KoboldRadio.ready
	
	KoboldRadio.game_save_file_loaded.connect( print.bind( "Game loaded!" ) )
	KoboldRadio.game_save_file_saved.connect( print.bind( "Game saved!" ) )
	
	var tree: SceneTree = Engine.get_main_loop()
	var world: World2D = ( tree.current_scene as Node2D ).get_world_2d()
	print( world.direct_space_state )
	
	load_file()


## load a game file[br]
## creates a new game if no file is found
static func load_file( file_path: String = SAVE_FILE_PATH ) -> void:
	
	var loaded_file: Resource
	if ( FileAccess.file_exists( file_path ) ):
		
		loaded_file = load( file_path )
	
	if ( loaded_file is SaveFile ):
		
		current_file = loaded_file
	else:
		
		current_file = SaveFile.new()
	
	KoboldRadio.game_save_file_loaded.emit( current_file )

## save a game file to disk
static func save_file( file_path: String = SAVE_FILE_PATH ) -> void:
	
	var status := ResourceSaver.save( current_file, file_path )
	if ( status != OK ):
		
		push_error( error_string( status ) )
	
	KoboldRadio.game_save_file_saved.emit()


## sets a secret flag in the game data[br]
## pls only use one flag at a time pls thanks =3
static func give_secret_flag( flag: SaveFile.SECRETS ) -> void:
	
	if ( not current_file.secrets_collected & flag ):
		
		current_file.secrets_collected &= flag
		current_file.secrets_counted += 1
		
		KoboldRadio.game_save_secret_found.emit( flag )
