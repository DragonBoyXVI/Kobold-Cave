@icon( "res://Dragon Game Template/Icons/node_health.png" )
@tool
extends Node
class_name NodeHealth
## Node that helps you track HP info
##
## This node provides signals and methods to help manage HP.


## emited before [Armour] calculation and before [Damage] is dealt
signal pre_hurt( damage: BaseDamage )
## emited arfter [Armour] calculation and [Damage] is dealt
signal hurt( damage: BaseDamage )

## emited before a [Heal] is applied
signal pre_healed( heal: BaseHeal )
## emited after a [Heal] is applied
signal healed( heal: BaseHeal )

## emited when health reaches 0
signal died()
## emitted if hp was below 0 and went above 0
signal revived()

## emited if an armour calculation happens
signal armour_info( info: ArmourDamageInfo )


## The [Health] resource to use
@export var health: Health :
	set( value ):
		notify_property_list_changed.call_deferred()
		update_configuration_warnings.call_deferred()
		
		health = value
## The [Armour] resource to use
@export var armour: BaseArmour


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not health ):
		
		const text := "NodeHealth needs a [Health] resource to function!"
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return

 
## called by hitboxes when they recive an event, can be called in code.
func recive_event( event: HurtboxEvent ) -> void:
	
	if ( not health ):
		
		push_error( "Recived event, but has no health resorce!\n", event )
	
	event.apply( self )

## used to apply armour to a damage object, emits emits a armour info object
func apply_armour( damage: BaseDamage ) -> void:
	
	if ( not armour ): return
	
	var info : ArmourDamageInfo = armour.apply( self, damage )
	armour_info.emit( info )
