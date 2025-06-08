@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
@tool
extends Resource
class_name TeamMask
## A team mask helps hitboxes and hurtboxes decide if they should
## hit eachother or not.
##
## Who needs collision layers?/j


## value for next instance created
static var _next_unique_index: int = 0


## enum showing what teams you have, feel free to edit these.
enum TEAMS {
	## the players team
	PLAYER = 1 << 0,
	## the enemies team
	ENEMY = 1 << 1,
	## secret third thing
	OTHER_GUYS = 1 << 2,
	
}

## flags the define how this interacts with other masks
enum HIT_FLAGS {
	## if true, this mask will hit targets on its own team
	FRIENDLY_FIRE = 1 << 0,
	## if true, this mask will hit itself
	HIT_SELF = 1 << 1,
	
}


## the mask representing what team(s) this is on.
var mask: int = 0
## these flags determine specific behaviours
var behaviour_flags: int = 0


## a integer that represents this unique resource
var _unique_index: int 


static func _get_unique_index() -> int:
	
	_next_unique_index += 1
	return _next_unique_index


func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "mask",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": DragonUtility.make_pretty_enum_keys( TEAMS.keys() )
	} )
	
	properties.append( {
		"name": "behaviour_flags",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": DragonUtility.make_pretty_enum_keys( HIT_FLAGS.keys() )
	} )
	
	return properties

func _init() -> void:
	
	_unique_index = _get_unique_index()


## returns true if this hits the other team
func does_hit_team( team: TeamMask ) -> bool:
	
	if ( behaviour_flags & HIT_FLAGS.HIT_SELF and self == team ):
		return true
	
	if ( behaviour_flags & HIT_FLAGS.FRIENDLY_FIRE ):
		return true
	
	return not ( mask & team.mask )
