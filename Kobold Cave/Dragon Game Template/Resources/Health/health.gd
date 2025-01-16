@tool
@icon( "res://Dragon Game Template/Icons/Element/life.png" )
extends ScalieResource
class_name Health
## Resource that tracks hp
##
## This resource tracks hp 


## emitted when hp values are changed
signal updated


## if true, hp is rounded to the nearest int
@export var rounded := true
## if true, max health is ignored
@export var ignore_max: bool = false
## the max health
@export_range( 0.0, 125.0, 0.01, "or_greater" ) var maximum: float :
	set( value ):
		
		if ( rounded ):
			
			maximum = roundf( value )
		else:
			
			maximum = value
		
		if ( _internal_update ):
			_internal_update = false
			
			if ( not ignore_max ):
				
				current = minf( current, maximum )
			
			percent = current / maximum
			
			updated.emit()
			_internal_update = true
## the current hp value
@export_range( 0.0, 125.0, 0.01, "or_greater" ) var current: float :
	set( value ):
		
		if ( rounded ):
			
			current = roundf( value )
		else:
			
			current = value
		
		if ( not ignore_max ):
			
			current = minf( current, maximum )
		
		if ( _internal_update ):
			_internal_update = false
			
			percent = current / maximum
			
			updated.emit()
			_internal_update = true
## the hp percent
@export_range( 0.0, 1.0, 0.01, "or_greater" ) var percent: float : 
	set( value ):
		
		percent = value
		
		if ( _internal_update ):
			_internal_update = false
			
			current = maximum * percent
			
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
