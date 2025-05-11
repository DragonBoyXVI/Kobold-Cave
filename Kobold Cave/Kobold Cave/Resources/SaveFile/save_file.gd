@icon( "uid://dtskp8fwxafd1" )
@tool
extends Resource
class_name SaveFile


## flags for what secrets exist
enum SECRETS {
	
}
## flags for what secrets have been collected
var secrets_collected: int = 0
## number of secrets colletced
var secrets_counted: int = 0


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
