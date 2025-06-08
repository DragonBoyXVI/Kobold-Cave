@icon( "res://Dragon Game Template/Icons/Armor/armour.png" )
extends Resource
class_name Armour
## A basic armour object.
##
## An armour resource interacts with [Damage] resources to reduce
## the damage they deal.


## reduces all damage, effected by the peirce property
@export var defence: int


func _to_string() -> String:
	
	const text := "Armour"
	return text


## used to apply the armor to the [Damage],
## the [DamageProfile] is used as refrence
func apply( _profile: DamageProfile, damage: Damage ) -> void:
	
	damage.amount -= maxi( 0, defence - damage.peirce )
