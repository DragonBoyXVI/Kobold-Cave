@icon( "res://Dragon Game Template/Icons/Armor/armour.png" )
extends ScalieResource
class_name BaseArmour
## A basic armour object.
##
## An armour resource interacts with [Damage] resources to reduce
## the damage they deal.


## reduces all damage, effected by the peirce property
@export var value: float
## same a regular value but for elements. not affected bt peirce.
@export var element_value: Array[ float ] = [ 0.0, 0.0, 0.0, 0.0, 0.0 ]


func _to_string() -> String:
	
	const text := "BaseArmour, not meant to be used directly."
	return text


## used to apply the armor to the [BaseDamage],
## used [NodeHealth] as a ref for calculations.
func apply( health_node: NodeHealth, damage: BaseDamage ) -> ArmourDamageInfo:
	var info := ArmourDamageInfo.new()
	
	_apply( info, health_node, damage )
	
	return info


## virtual[br]
## this function changes the [Damage] object, reducing its damage
## based on whatever you want.[br]
## be sure to log stuff into the info, incase you have something
## that uses it
func _apply( info: ArmourDamageInfo, _health_node: NodeHealth, _damage: BaseDamage ) -> void:
	
	info.messages.append( "Apply method was not implimented!" )
	push_error( "Not implimented: Armour._apply()\n", self )
	pass
