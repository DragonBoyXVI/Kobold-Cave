
extends Node
## game manager


enum GAME_MODE {
	STORY,
	STORY_TRIAL,
	LEVEL_TRIAL,
	
	FREEPLAY
}

var current_game_mode: GAME_MODE


func _ready() -> void:
	
	KoboldRadio.level_clear_next_pressed.connect( _radio_on_level_clear_next_pressed )


#region story

const story_levels: PackedStringArray = [
	#"res://test_world.tscn",
	"uid://oqjluqp5ko3j",
	"res://Kobold Cave/Levels/Sketch/0/level_wake_room.tscn",
	"res://Kobold Cave/Levels/Sketch/1/level_show_off_bombs.tscn",
	"res://Kobold Cave/Levels/Sketch/2/level_pit_bomb_ghosts.tscn",
	"res://Kobold Cave/Levels/Sketch/3/level_climb_the_drill.tscn",
	"res://Kobold Cave/Levels/Sketch/4/level_gtfo.tscn"
]
var story_position: int = -1

func story_advance() -> void:
	story_position += 1
	
	if ( story_position < story_levels.size() ):
		
		await GUI.fade_out()
		get_tree().change_scene_to_file( story_levels[ story_position ] )
		KoboldUtility.in_level_trans = true
		KoboldRadio.room_pause.emit()
		await GUI.fade_in(  )
		KoboldUtility.in_level_trans = false
		KoboldRadio.room_unpause.emit()
		DragonControler.can_toggle_pause = true
	else:
		
		# story beaten
		get_tree().quit()


#endregion story


func _radio_on_level_clear_next_pressed() -> void:
	
	story_advance()
