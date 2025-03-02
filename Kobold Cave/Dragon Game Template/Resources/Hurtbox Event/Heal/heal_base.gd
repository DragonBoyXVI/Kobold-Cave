@icon( "res://Dragon Game Template/Icons/Hurtbox Events/Heal/heal_abstract.png" )
extends HurtboxEvent
class_name Heal
## Base for healing
##
## A basic heal, usable as a base for other healing types


## the amount of healing
@export var amount: int


func _to_string() -> String:
	
	const text := "Heal\nAmount: %s"
	return text % amount

func _to_color() -> Color:
	
	return ELEMENT_COLOR[ ELEMENT.LIFE ]

func _init( amt := 0 ) -> void:
	
	amount = amt

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

## Virtual[br]
## Used to heal the health node.[br]
## Should return true if healing was actually done.
func _heal( health_node: NodeHealth ) -> bool:
	
	if ( amount <= 0.0 ): return false
	
	health_node.health.current += amount
	return true
