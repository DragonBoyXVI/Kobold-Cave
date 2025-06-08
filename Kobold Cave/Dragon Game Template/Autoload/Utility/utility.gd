
extends Object
class_name DragonUtility
## Some utility funcs
##
## ditto


enum test{
	ONE,
	TWO,
	THREE
}


## used to make nicer looking enum key names for the editor
static func make_pretty_enum_keys( keys: PackedStringArray ) -> String:
	
	var pretty_keys: String = ""
	for key: String in keys:
		
		pretty_keys += key.capitalize() + ","
	
	return pretty_keys
