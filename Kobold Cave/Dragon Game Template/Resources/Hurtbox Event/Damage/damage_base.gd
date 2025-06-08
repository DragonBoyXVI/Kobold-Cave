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
@export var element: Element


func _to_string() -> String:
	
	const text := "Damage\nAmount: {0}, Peirce: {1}, Element: {2}"
	return text.format( [ amount, peirce, element ] )

func _to_color() -> Color:
	
	# wip
	return Color.RED

func _init( amt: int = 0, prc: int = 0, elem: Element = null ) -> void:
	
	amount = amt
	peirce = prc
	element = elem

## used to calculate damage before elemental bonus is applied
func pre_calculate( _profile: DamageProfile ) -> void:
	pass

## used to calculate damage before armour is applied
func calculate( _profile: DamageProfile ) -> void:
	pass

## used to calculate damage after armour is applied
func post_calculate( _profile: DamageProfile ) -> void:
	pass


## used to turn this into a heal object
func to_heal() -> Heal:
	
	return _to_heal()

## Virtual[br]
func _to_heal() -> Heal:
	
	return Heal.new()
