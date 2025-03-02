@tool
@icon( "res://Dragon Game Template/Icons/Element/life.png" )
extends ScalieResource
class_name Health
## Resource that tracks hp
##
## This resource tracks hp 


## emitted when hp values are changed
signal updated


## if true, max health is ignored
@export var ignore_max: bool = false
## the max health
@export_range( 0, 125, 1, "or_greater" ) var maximum: int :
	set( value ):
		
		maximum = value
		
		if ( _internal_update ):
			_internal_update = false
			
			if ( not ignore_max ):
				
				current = mini( current, maximum )
			
			if ( maximum == 0 ):
				
				percent = 1.0
			else:
				
				percent = current / float( maximum )
			
			updated.emit()
			_internal_update = true
## the current hp value
@export_range( 0, 125, 1, "or_greater" ) var current: int :
	set( value ):
		
		if ( ignore_max ):
			
			current = value
		else:
			
			current = mini( value, maximum )
		
		if ( _internal_update ):
			_internal_update = false
			
			percent = current / float( maximum )
			
			updated.emit()
			_internal_update = true
## the hp percent
@export_range( 0.0, 1.0, 0.01, "or_greater" ) var percent: float : 
	set( value ):
		
		percent = value
		
		if ( _internal_update ):
			_internal_update = false
			
			current = roundi( maximum * percent )
			
			updated.emit()
			_internal_update = true

## these flags determine what elements this should be healed by
var element_heal_flag: int = ELEMENT_BITS.LIFE


var _internal_update := true


func _to_string() -> String:
	
	const text := "Health resource"
	return text

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "element_heal_flag",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": pretty_enum_keys( ELEMENT_BITS.keys() )
	} )
	
	return properties
