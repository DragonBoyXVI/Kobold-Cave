@icon( "res://Dragon Game Template/Icons/Hurtbox Events/Damage/damage_abstract.png" )
extends HurtboxEvent
class_name Damage
## Most basic class for dealing damage to [NodeHealth]
##
## A base class for damage. 
## Ideally you'd be making custom [Armour], as that
## provides more flexibility with custom code.


## the amount of damage
@export var amount: int
## armour uses this to reduce its effectiveness
@export var peirce: int
## armour also uses this, with other stuff
@export var element := ELEMENT.NONE


func _to_string() -> String:
	
	const text := "Damage\nAmount: {0}, Peirce: {1}, Element: {2}"
	return text.format( [ amount, peirce, element ] )

func _to_color() -> Color:
	
	if ( element == ELEMENT.NONE ): return Color.RED
	
	return ELEMENT_COLOR[ element ]

func _init( amt := 0, elem := ELEMENT.NONE, peir := 0 ) -> void:
	
	amount = amt
	peirce = peir
	element = elem

func apply( node_health: NodeHealth ) -> void:
	
	if ( health_is_healed_by_this( node_health.health ) ):
		
		node_health.recive_event( to_heal() )
		return
	
	node_health.pre_hurt.emit( self )
	
	node_health.apply_armour( self )
	_calculate( node_health )
	
	var did_damage := _damage( node_health )
	if ( did_damage ):
		
		node_health.hurt.emit( self )


## used to turn this into a heal object
func to_heal() -> Heal:
	
	return _to_heal()

## used to tell if this should heal a [Health] resource
func health_is_healed_by_this( health: Health ) -> bool:
	
	return _health_is_healed_by_this( health )


## virtual[br]
## used so the damage object can modify itself before
## doing damage and after armour has affected it.
func _calculate( _health_node: NodeHealth ) -> void:
	
	pass

## virtual[br]
## called when this heals instead of damages
func _to_heal() -> Heal:
	
	return Heal.new( amount )

## virtual[br]
## used to test if this heals the health instead of damage it.
func _health_is_healed_by_this( health: Health ) -> bool:
	
	if ( element == ELEMENT.NONE ): return false
	
	return ( health.element_heal_flag & 1 << element )

## virtual[br]
## used to actually do damage to the node.[br]
## should return true if damage was actually done.
func _damage( node_health: NodeHealth ) -> bool:
	
	if ( amount > 0 ):
		
		node_health.health.current -= amount
		return true
	
	return false
