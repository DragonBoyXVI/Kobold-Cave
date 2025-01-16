extends BaseArmour
class_name Armour
## basic armour that handles peirce and elements
##
## A simplistic armour that subtracts incoming damage.


func _to_string() -> String:
	
	const text := "Armour\nValue: {0}, Elements: {1}"
	return text.format( [ value, element_value ] )


func _apply( info: ArmourDamageInfo, _health_node: NodeHealth, damage: BaseDamage ) -> void:
	
	var final_armour := value
	if ( value > 0.0 ):
		
		final_armour -= damage.peirce
	info.flat_armor += final_armour
	
	if ( damage.element != ELEMENT.NONE ):
		
		final_armour += element_value[ damage.element ]
		info.elemental += element_value[ damage.element ]
	
	damage.amount -= final_armour
