@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
@tool
extends Resource
class_name Element
## A mask/helper for element related systems
##
## Built in pokemon esque element table


## a place to cache elemental calculations.
## you could tottaly precalc all these but i wont,
## calcing it once at runtime aint that expensive
static var _cache: Dictionary[ String, float ] = {}


## The fire element
const FIRE = BITS.FIRE
## The ice element
const ICE = BITS.ICE
## The life element
const LIFE = BITS.LIFE
## The venom element
const VENOM = BITS.VENOM
## The electric element
const ELEC = BITS.ELEC


## Element bit table
enum BITS {
	## the fire element
	FIRE = 1<<0,
	## the ice element
	ICE = 1<<1,
	## the life element
	LIFE = 1<<2,
	## the venom element
	VENOM = 1<<3,
	## the electric element
	ELEC = 1<<4,
}

## here for storage
const COLOR: PackedColorArray = [
	Color.ORANGE_RED, ## Fire
	Color.AQUA, ## Ice
	Color.LAWN_GREEN, ## Life
	Color.WEB_PURPLE, ## Poison
	Color.YELLOW ## Electricity
	
]

#region elem table

## multiplier for when an element is strong against a defender
const STRONG := 2.0
## multiplier for when an element is nuetral against a defender
const NORMAL := 1.0
## multiplier for when an element is weak against a defender
const WEAK := 0.5

## Table of how effective fire damage is
const TABLE_FIRE: Dictionary[ int, float ] = {
	FIRE: NORMAL,
	ICE: STRONG,
	LIFE: NORMAL,
	VENOM: STRONG,
	ELEC: WEAK
}
## Table of how effective ice damage is
const TABLE_ICE: Dictionary[ int, float ] = {
	FIRE: STRONG,
	ICE: NORMAL,
	LIFE: STRONG,
	VENOM: WEAK,
	ELEC: WEAK
}
## Table of how effective life damage is
const TABLE_LIFE: Dictionary[ int, float ] = {
	FIRE: NORMAL,
	ICE: NORMAL,
	LIFE: NORMAL,
	VENOM: WEAK,
	ELEC: STRONG
}
## Table of how effective venom damage is
const TABLE_VENOM: Dictionary[ int, float ] = {
	FIRE: WEAK,
	ICE: STRONG,
	LIFE: STRONG,
	VENOM: WEAK,
	ELEC: WEAK
}
## Table of how effective electric damage is
const TABLE_ELEC: Dictionary[ int, float ] = {
	FIRE: NORMAL,
	ICE: STRONG,
	LIFE: NORMAL,
	VENOM: STRONG,
	ELEC: STRONG
}


## Lookup table of tables, makes automation easier
const TABLES: Dictionary[ int, Dictionary ] = {
	FIRE: TABLE_FIRE,
	ICE: TABLE_ICE,
	LIFE: TABLE_LIFE,
	VENOM: TABLE_VENOM,
	ELEC: TABLE_ELEC
}

#endregion elem table

## flag table for what elements this has.
var elements: int = 0:
	set( val ):
		
		if ( val == elements ): return
		
		elements = val
		emit_changed()


func _to_string() -> String:
	
	const text := "Element: %s"
	var format := String()
	
	if ( elements & FIRE ):
		
		format += "Fire, "
	if ( elements & ICE ):
		
		format += "ICE, "
	if ( elements & LIFE ):
		
		format += "Life, "
	if ( elements & VENOM ):
		
		format += "Venom, "
	if ( elements & ELEC ):
		
		format += "Electricity, "
	
	return text % format

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "Element Table",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	} )
	
	properties.append( {
		"name": "elements",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": DragonUtility.make_pretty_enum_keys( BITS.keys() )
	} )
	
	return properties

func _init( elems: int = 0 ) -> void:
	
	elements = elems


## returns the power value of an attack of this element
## used against the defending element.[br]
## the defending element being the one provided to the func.
func get_offense_value_against( defence: Element ) -> float:
	# early out
	if ( elements == 0 ): return 1.0
	if ( defence.elements == 0 ): return 1.0
	var offence_value := 1.0
	
	# check cache
	var cache_key: String = str( elements, ":", defence.elements )
	if ( _cache.has( cache_key ) ):
		
		return _cache[ cache_key ]
	
	# calculate
	for element: int in BITS.values():
		#var element: int = 1 << i
		if ( elements & element ):
			
			offence_value *= _get_offense_for_single( element, defence )
	
	# store
	_cache[ cache_key ] = offence_value
	
	return offence_value

## helper that runs a loop for a single element
func _get_offense_for_single( element: int, defence: Element ) -> float:
	var offence_value := 1.0
	
	for def_element: int in BITS.values():
		#var def_element: int = 1 << i
		if ( defence.elements & def_element ):
			
			offence_value *= TABLES[ element ][ def_element ]
	
	return offence_value
