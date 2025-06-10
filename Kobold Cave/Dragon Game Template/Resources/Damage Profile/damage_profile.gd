@tool
extends Resource
class_name DamageProfile
## Profile to be used in damage calculations
##
## ditto


## emitted before any damage calculation takes place
signal pre_damage( damage: Damage )
## emitted before any heal calculation takes place
signal pre_heal( heal: Heal )

## emitted when this takes damage
signal took_damage( damage: Damage )
## emitted when this heals
signal took_heal( heal: Heal )

## emitted when this is hit by damage thats reduced to 0 or less
signal blocked_damage( damage: Damage )
## emitted when this is hit by healing thats reduced to 0 or less
signal blocked_heal( heal: Heal )

## emitted when health is 0 or less
signal died


## The health this profile uses.
## Can never be empty, so if you remove it, a new one is made
@export var health: Health :
	set( new ):
		
		health = new if new != null else Health.new()
		emit_changed()
## The armour this profile uses.
## if empty, armor is ignored
@export var armour: Armour
## the element of this profile.
## if empty, treated as being non-elemental
@export var element: Element


func _init() -> void:
	
	if ( not health ):
		
		health = Health.new()


func take_damage( damage: Damage ) -> void:
	
	pre_damage.emit( damage )
	
	damage.pre_calculate( self )
	
	if ( element and damage.element ):
		
		damage.amount = roundi( damage.amount * damage.element.get_offense_value_against( element ) )
	
	damage.calculate( self )
	
	if ( armour ):
		
		armour.apply( self, damage )
	
	damage.post_calculate( self )
	
	
	if ( damage.amount <= 0 ): 
		
		blocked_damage.emit( damage )
		return
	
	
	health.current -= damage.amount
	took_damage.emit( damage )
	
	if ( health.current <= 0 ):
		
		died.emit()

func take_heal( heal: Heal ) -> void:
	
	pre_heal.emit( heal )
	
	if ( heal.amount <= 0 ): 
		
		blocked_heal.emit( heal )
		return
	
	health.current += heal.amount
	took_heal.emit( heal )
	
	if ( health.current <= 0 ):
		
		died.emit()
