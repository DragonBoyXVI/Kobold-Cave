@tool
@icon( "res://Dragon Game Template/Icons/Armor/armour_guts.png" )
extends Armour
class_name ArmourGuts
## Armour that prevents insta kills
## 
## This armour protects you from dying if you are above a 
## specified hp threshold.


## what to check when activating guts
enum GUTS_MODE {
	## check health percent
	PERCENT,
	## check the current health value
	ABSOLUTE
}


## if above this percent hp, activate guts
var guts_percent_limit: float
## when guts activates, set to this hp %
var guts_percent_set_to: float

## if above this hp, activate guts
var guts_absolute_limit: int
## when guts activates, set to this hp value
var guts_absolute_set_to: int

## the mode to use
var guts_mode := GUTS_MODE.PERCENT : 
	set( value ):
		notify_property_list_changed.call_deferred()
		
		guts_mode = value



func _to_string() -> String:
	
	var prev_text := super()
	const text := "ArmourGuts\nMode: {0}, Limit: {1}, Set to: {2}"
	
	var format: Array
	if ( guts_mode == GUTS_MODE.PERCENT ):
		
		format = [ "Percent", guts_percent_limit, guts_percent_set_to ]
	else:
		
		format = [ "Absolute", guts_absolute_limit, guts_absolute_set_to ]
	
	return prev_text + "\n" + ( text.format( format ) )

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	properties.append( {
		"name": "Guts",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
		"hint_string": "guts_"
	} )
	
	properties.append( {
		"name": "guts_mode",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": pretty_enum_keys( GUTS_MODE.keys() )
	} )
	
	match guts_mode:
		
		GUTS_MODE.PERCENT:
			
			properties.append( {
				"name": "Percent",
				"type": TYPE_NIL,
				"usage": PROPERTY_USAGE_SUBGROUP,
				"hint_string": "guts_percent_"
			} )
			
			properties.append( {
				"name": "guts_percent_limit",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.0,1.0,0.01"
			} )
			
			properties.append( {
				"name": "guts_percent_set_to",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.0,1.0,0.01"
			} )
		
		GUTS_MODE.ABSOLUTE:
			
			properties.append( {
				"name": "Absloute",
				"type": TYPE_NIL,
				"usage": PROPERTY_USAGE_SUBGROUP,
				"hint_string": "guts_absolute_"
			} )
			
			properties.append( {
				"name": "guts_absolute_limit",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.0,125.0,0.05"
			} )
			
			properties.append( {
				"name": "guts_absolute_set_to",
				"type": TYPE_FLOAT,
				"hint": PROPERTY_HINT_RANGE,
				"hint_string": "0.0,125.0,0.05"
			} )
	
	return properties


func _apply( info: ArmourDamageInfo, health_node: NodeHealth, damage: Damage ) -> void:
	super( info, health_node, damage )
	
	var health: Health = health_node.health
	
	var limit := guts_absolute_limit
	if ( guts_mode == GUTS_MODE.PERCENT ):
		
		limit = roundi( health.maximum * guts_percent_limit )
	
	if ( health.current > limit ):
		
		if ( health.current - damage.amount <= 0.0 ):
			
			var set_to := guts_absolute_set_to
			if ( guts_mode == GUTS_MODE.PERCENT ):
				
				set_to = roundi( guts_percent_set_to * health.maximum )
			
			var hp_diff := absi( health.current - set_to )
			var prev_damage := damage.amount
			
			damage.amount = hp_diff
			info.misc += ( prev_damage - damage.amount )
			info.messages.append( "GUTS: %s" % ( prev_damage - damage.amount ) )
	
	pass
