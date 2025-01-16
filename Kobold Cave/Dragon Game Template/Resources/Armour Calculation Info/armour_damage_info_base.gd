@icon( "res://Dragon Game Template/Icons/armor_damage_info.png" )
extends RefCounted
class_name ArmourDamageInfo
## Tracks info about what happens in a [Armour] calculation
##
## Does what it says on the tin! a bunch of numbers kept in a resource. [br]
## most of this will depend on what type of damage and armour is being used.


## damage reduced by having any kind of armour
var flat_armor: float :
	set( value ):
		total += value - flat_armor
		flat_armor = value
## damage reduced becasue the damage had an elemental type
var elemental: float :
	set( value ):
		total += value - elemental
		elemental = value
## damage reduced due to gimicks
var misc: float :
	set( value ):
		total += value - misc
		misc = value
## total damage reduced
var total: float


## Extra tidbits you want specified in the print
var messages: PackedStringArray = []


## combines the two info objects
func combine( other: ArmourDamageInfo ) -> void:
	
	flat_armor += other.flat_armor
	elemental += other.elemental
	misc += other.misc
	
	messages.append_array( other.messages )


func _to_string() -> String:
	
	const text := "ArmourDamageInfo\nFlat: {flat}\nElement: {elem}\nMisc: {misc}\nTotal: {total}\nMessages: {msg}"
	return text.format( {
		"flat": flat_armor,
		"elem": elemental,
		"misc": misc,
		"total": total,
		"msg": messages
		
	} )
