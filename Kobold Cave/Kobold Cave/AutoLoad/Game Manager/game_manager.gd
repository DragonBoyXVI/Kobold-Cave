
extends Node
## game manager


enum GAME_MODE {
	STORY,
	STORY_TRIAL,
	LEVEL_TRIAL,
	
	FREEPLAY
}

var current_game_mode: GAME_MODE


#region story

const story_levels: PackedStringArray = [
	
]
var story_position: int = -1




#endregion story
