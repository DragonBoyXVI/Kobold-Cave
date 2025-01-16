extends BaseDamage
class_name Damage
## Simple damage
##
## A simple damage object, created from the overcomplicated base =3


func _init( amt := 0.0, elem := ELEMENT.NONE, peir := 0.0 ) -> void:
	
	amount = amt
	peirce = peir
	element = elem

func _to_color() -> Color:
	
	if ( element == ELEMENT.NONE ): return Color.RED
	
	return ELEMENT_COLOR[ element ]

func _to_heal() -> BaseHeal:
	
	return Heal.new( amount )

func _to_string() -> String:
	
	const text := "Damage\nAmount: {0}, Peirce: {1}, Element: {2}"
	return text.format( [ amount, peirce, element ] )

func _health_is_healed_by_this( health: Health ) -> bool:
	
	if ( element == ELEMENT.NONE ): return false
	
	return ( health.element_heal_flag & 1 << element )

func _damage( health_node: NodeHealth ) -> bool:
	
	if ( amount <= 0.0 ): return false
	
	health_node.health.current -= amount
	return true
