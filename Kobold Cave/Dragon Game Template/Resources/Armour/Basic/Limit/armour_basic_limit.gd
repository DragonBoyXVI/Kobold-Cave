@tool
@icon( "res://Dragon Game Template/Icons/Armor/armour_limit.png" )
extends Armour
class_name ArmourLimit
## Armour that limits damage to a range of values.
##
## This limits the amount property of [BaseDamage] to a range,
## good for enemies that take damage 1 hp at a time.


@export_group( "Limit", "limit_" )
@export_range( 0.0, 125.0, 0.05, "or_greater" ) var limit_lower: float : 
	set( value ):
		
		limit_lower = minf( value, limit_upper )
@export_range( 0.0, 125.0, 0.05, "or_greater" ) var limit_upper: float :
	set( value ):
		
		limit_upper = maxf( value, limit_lower )


func _apply( info: ArmourDamageInfo, health_node: NodeHealth, damage: BaseDamage ) -> void:
	super( info, health_node, damage )
	
	if ( damage.amount > limit_upper or damage.amount < limit_lower ):
		
		var prev_damage := damage.amount
		
		damage.amount = clampf( damage.amount, limit_lower, limit_upper )
		
		info.misc += ( prev_damage - damage.amount )
		info.messages.append( "Armour Limit: %s" % ( damage.amount - prev_damage ) )
