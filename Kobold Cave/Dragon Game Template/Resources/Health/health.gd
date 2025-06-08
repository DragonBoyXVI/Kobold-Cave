@tool
@icon( "res://Dragon Game Template/Icons/Element/life.png" )
extends Resource
class_name Health
## Resource that tracks hp
##
## This resource tracks hp 


## emitted when hp values change
signal hp_changed


## if true, max health is ignored
@export var ignore_max: bool = false
## the max health
@export_range( 0, 125, 1, "or_greater" ) var maximum: int :
	set( value ):
		
		if ( maximum == value ): return
		
		maximum = value
		
		if ( not ignore_max ):
			
			current = mini( current, maximum )
## the current hp value
@export_range( 0, 125, 1, "or_greater" ) var current: int :
	set( value ):
		
		if ( ignore_max ):
			
			current = value
		else:
			
			current = mini( value, maximum )
		
		hp_changed.emit()


## gives hp as a percent from 0.0 to 1.0[br]
## if ignore_max_hp is true, or a wrong devision is made, this returns 1.0
func as_percent() -> float:
	
	if ( ignore_max ):
		
		return 1.0
	else:
		
		var percent: float = current / float( maximum )
		return percent if is_finite( percent ) else 1.0

## sets the current hp to be a percent on max hp
func set_percent( percent: float ) -> void:
	
	current = roundi( maximum * percent )


func _to_string() -> String:
	
	const text := "Health resource"
	return text
