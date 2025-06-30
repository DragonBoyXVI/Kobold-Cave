
extends Object
class_name GameManager
## manages some game elements
##
## ditto


enum GAME_MODE {
	STORY,
	STORY_TRIAL,
	LEVEL_TRIAL,
	
	FREEPLAY
}

var current_game_mode: GAME_MODE


static func advance() -> void:
	
	# swicth here
	story_advance()


#region story

const story_levels: PackedStringArray = [
	#"res://test_world.tscn",
	"uid://oqjluqp5ko3j", # wake up room
	
	"uid://b5uovsjcen7yj",
	"uid://dwiu0froolirj",
	"uid://dxaekk8ttmo1l",
	"",
	"",
	
]
static var story_position: int = -1

static func story_advance() -> void:
	story_position += 1
	
	if ( story_position < story_levels.size() ):
		
		await GUI.fade_out()
		Engine.get_main_loop().change_scene_to_file( story_levels[ story_position ] )
		KoboldUtility.in_level_trans = true
		KoboldRadio.room_pause.emit()
		DragonPauser.is_togglable = false
		await GUI.fade_in(  )
		KoboldRadio.room_unpause.emit()
		KoboldUtility.in_level_trans = false
		DragonPauser.is_togglable = true
	else:
		
		# story beaten
		Engine.get_main_loop().quit()


#endregion story
