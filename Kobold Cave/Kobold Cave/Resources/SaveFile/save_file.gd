@icon( "uid://dtskp8fwxafd1" )
@tool
extends Resource
class_name SaveFile


## flags for what secrets exist
enum SECRETS {
	
	NO_SECRET = 0,
	
	LV_1_BOMB_ROOM = 1<<1,
	LV_1_ROOM_ABOVE_SPAWN = 1<<2,
	
}
## flags for what secrets have been collected
var secrets_collected: int = 0
## number of secrets colletced
var secrets_counted: int = 0


enum LEVEL {
	NONE = -1,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
}
## time is tracked in seconds
@export var level_best_times: Dictionary[ LEVEL, float ] = {}
## stores the best time in the save file. If the saved time is better, this returns true[br]
## pls provide time in seconds
func level_set_time_best( level: LEVEL, time: float ) -> bool:
	
	if ( level == LEVEL.NONE ): return false
	
	if ( level_best_times.has( level ) ):
		
		var is_best: bool = level_best_times[ level ] < time
		level_best_times[ level ] = maxf( level_best_times[ level ], time )
		return is_best
	else:
		
		level_best_times[ level ] = time
		return true

func level_get_time( level: LEVEL ) -> float:
	
	if ( level_best_times.has( level ) ):
		
		return level_best_times[ level ]
	
	return 0.0


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "Secrets",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "secrets_"
	} )
	
	properties.append( {
		"name": "secrets_collected",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": ",".join( SECRETS.keys() )
	} )
	
	properties.append( {
		"name": "secrets_counted",
		"type": TYPE_INT
	} )
	
	return properties
