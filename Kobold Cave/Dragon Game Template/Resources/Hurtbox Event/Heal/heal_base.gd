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
	
	return Element.COLOR[ 2 ]

func _init( amt := 0 ) -> void:
	
	amount = amt
