@icon( "res://Dragon Game Template/Icons/Hurtbox Events/Heal/heal_abstract.png" )
extends HurtboxEvent
class_name BaseHeal
## Base for healing
##
## Provides a base to create your own custom heal branch.


## the amount of healing
@export var amount: float


func _to_string() -> String:
	
	const text := "BaseHeal, not meant to be used directly"
	return text

func _to_color() -> Color:
	
	return ELEMENT_COLOR[ ELEMENT.LIFE ]


func apply( health_node: NodeHealth ) -> void:
	
	health_node.pre_healed.emit( self )
	
	_calculate( health_node )
	
	var did_heal := _heal( health_node )
	if ( did_heal ):
		
		health_node.healed.emit( self )


## virtual[br]
## used so the heal object can modify itself before healing
func _calculate( _health_node: NodeHealth ) -> void:
	pass
	#push_error( "NOT IMPLIENTED: Heal._caculate()", self )

## Virtual[br]
## Used to heal the health node.[br]
## Should return true if healing was actually done.
func _heal( _health_node: NodeHealth ) -> bool:
	
	push_error( "NOT IMPLIENTED: Heal._heal()", self )
	return false
