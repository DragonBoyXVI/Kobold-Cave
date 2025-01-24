@icon( "res://Dragon Game Template/Icons/Hurtbox Events/Damage/damage_abstract.png" )
extends HurtboxEvent
class_name BaseDamage
## Most basic class for dealing damage to [NodeHealth]
##
## This is the most stripped down and bare bones damage object i
## could make. Ideally you'd be making custom [Armour], as that
## provides more flexibility with custom code.


## the amount of damage
@export var amount: float
## armour uses this to reduce its effectiveness
@export var peirce: float
## armour also uses this, with other stuff
@export var element := ELEMENT.NONE
## if true, the damage is rounded to the nearest int before
## _damage is called
@export var rounded := true


func _to_string() -> String:
	
	const text := "BaseDamage, not meant to be used directly\nAmount: {0}, Element: {1}, Peirce: {2}"
	return text.format( [ amount, element, peirce ] )

func _to_color() -> Color:
	
	push_error( "NOT IMPLIENTED: Damage._to_color()", self )
	return Color.RED


func apply( node_health: NodeHealth ) -> void:
	
	if ( health_is_healed_by_this( node_health.health ) ):
		
		node_health.recive_event( to_heal() )
	
	node_health.pre_hurt.emit( self )
	
	node_health.apply_armour( self )
	_calculate( node_health )
	
	if ( rounded ):
		
		amount = roundf( amount )
	
	var did_damage := _damage( node_health )
	if ( did_damage ):
		
		node_health.hurt.emit( self )
		if ( node_health.health.current <= 0.0 ):
			
			node_health.died.emit()


## used to turn this into a heal object
func to_heal() -> BaseHeal:
	
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
func _to_heal() -> BaseHeal:
	
	push_error( "NOT IMPLIENTED: Damage._to_heal()", self )
	return BaseHeal.new()

## virtual[br]
## used to test if this heals the health instead of damage it.
func _health_is_healed_by_this( _health: Health ) -> bool:
	
	push_error( "NOT IMPLIENTED: Damage._health_is_healed_by_this()", self )
	return false

## virtual[br]
## used to actually do damage to the node.[br]
## should return true if damage was actually done.
func _damage( _node_health: NodeHealth ) -> bool:
	
	push_error( "NOT IMPLIMENTED: Damage._damage()\n", self )
	return false
