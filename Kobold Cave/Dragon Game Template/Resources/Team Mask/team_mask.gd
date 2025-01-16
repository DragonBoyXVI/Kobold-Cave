@tool
extends ScalieResource
class_name TeamMask
## A team mask helps hitboxes and hurtboxes decide if they should
## hit eachother or not.
##
## Who needs collision layers?/j


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
	
}


## the mask representing what team(s) this is on.
var mask: int = 0
## these flags determine specific behaviours
var behaviour_flags: int = 0

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "mask",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": pretty_enum_keys( TEAMS.keys() )
	} )
	
	properties.append( {
		"name": "behaviour_flags",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": pretty_enum_keys( HIT_FLAGS.keys() )
	} )
	
	return properties


## returns true if we hit the other team
func does_hit_team( team: TeamMask ) -> bool:
	
	if ( behaviour_flags & HIT_FLAGS.FRIENDLY_FIRE ):
		return true
	
	# if two flags are both set, return true
	return not ( mask & team.mask )
