@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends Resource
class_name ScalieResource
## Base class for any resource used by the DragonTemplate
##
## This base class is used for all resources used by the DragonTemplate.[br]


func _to_string() -> String:
	
	const text := "ScalieResource, musta forgot to overwrite this"
	return text


## Enum for the element system
enum ELEMENT {
	FIRE, ## Fire
	ICE, ## Ice
	LIFE, ## Life
	POISON, ## Poison
	ELEC, ## Electricity
	
	NONE ## No Element[br]Useless in Bitflags
	
}

## Same as element enum, but bit shifted and without "none"
enum ELEMENT_BITS {
	FIRE = 1 << 0, ## Fire
	ICE = 1 << 1, ## Ice
	LIFE = 1 << 2, ## Life
	POSION = 1 << 3, ## Poison
	ELEC = 1 << 4 ## Electricity
	
}

## Array that holds the colors for the elements
const ELEMENT_COLOR: PackedColorArray = [
	Color.ORANGE_RED, ## Fire
	Color.AQUA, ## Ice
	Color.LAWN_GREEN, ## Life
	Color.WEB_PURPLE, ## Poison
	Color.YELLOW ## Electricity
	
]



## used to make enum keys pretty in the editor
static func pretty_enum_keys( keys: PackedStringArray ) -> String:
	var new_keys := PackedStringArray()
	new_keys.resize( keys.size() )
	
	var key: String
	var first_char: String
	var lower_chars: String
	for index: int in keys.size():
		
		key = keys[ index ]
		
		# makes the first character a capital, and the rest lower
		first_char = key[ 0 ].to_upper()
		lower_chars = key.to_lower()
		lower_chars[ 0 ] = first_char
		
		new_keys[ index ] = lower_chars.replace( "_", " " )
	
	return ",".join( new_keys )
