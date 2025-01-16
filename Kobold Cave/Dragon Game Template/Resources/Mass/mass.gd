@icon( "res://Dragon Game Template/Icons/mass.png" )
@tool
extends ScalieResource
class_name Mass
## Class for handling object mass
##
## This class gives you the ability to work with mass
## note: this is basically the same as Temperature but for mass instead


@export_group( "Mass" )
## weight in pounds
@export var pounds: float :
	set( value ):
		pounds = value
		
		if ( _update_others ):
			_update_others = false
			
			grams = pounds_to_grams( pounds )
			kilograms = pounds_to_kilograms( pounds )
			tonnes = pounds_to_tonnes( pounds )
			
			_update_others = true
		
		mass_changed.emit( self )

## weight in grams
@export var grams: float :
	set( value ):
		grams = value
		
		if ( _update_others ):
			_update_others = false
			
			pounds = grams_to_pounds( grams )
			kilograms = grams_to_kilograms( grams )
			tonnes = grams_to_tonnes( grams )
			
			_update_others = true
## weight in kilograms
@export var kilograms: float :
	set( value ):
		kilograms = value
		
		if ( _update_others ):
			_update_others = false
			
			pounds = kilograms_to_pounds( kilograms )
			grams = kilograms_to_grams( kilograms )
			tonnes = kilograms_to_tonnes( kilograms )
			
			_update_others = true
## weigth in metric tonnes
@export var tonnes: float :
	set( value ):
		tonnes = value
		
		if ( _update_others ):
			_update_others = false
			
			pounds = tonnes_to_pounds( tonnes )
			grams = tonnes_to_grams( tonnes )
			kilograms = tonnes_to_kilograms( tonnes )
			
			_update_others = true

@export_group( "Thermal Properties" )
## Used in [Temperature] transfer.[br]
## Conductivity determins how quickly an object heat/cools, written in joules per second.[br]
## between two [Mass]es, the lowest conductivity is used.
@export var thermal_conductivity: float
## Used in [Temperature] transfer.[br]
## specific heat capacity determins how much energy an object can
## absorb before it heats up.[br]
## measured using ( joules / gram ) / degree C
@export var specific_heat_capacity: float


## to prevent loops
var _update_others := true


## emitted when weight changes
signal mass_changed( mass: Mass )


## for math between metric and imperial
const metric_to_pound_mult := 2.205
## for metric math
const metric_mult := 1000.0


## the weight scale
enum SCALE {
	LBS, ## pounds
	G, ## grams
	KG, ## kilograms
	T ## tonnes
	
}

## some common marks
enum COMMON_MARKS {
	HUMAN_WEIGHT, ## the average weight of a person, 68 kg (idk where this number came from lel)
	STONE, ## the weight of 1 stone, 14 pounds
	
}



func _to_string() -> String:
	
	const text := "\nMass\nPounds: {0}\nGrams: {1}\nKilograms: {2}\nTonnes: {3}"
	return text.format( [ pounds, grams, kilograms, tonnes ] )


## returns the mass difference
func get_difference( who: Mass, type := SCALE.G ) -> float:
	
	if ( type == SCALE.LBS ):
		return absf( pounds - who.pounds )
	elif ( type == SCALE.G ):
		return absf( grams - who.grams )
	elif ( type == SCALE.KG ):
		return absf( kilograms - who.kilograms )
	elif ( type == SCALE.T ):
		return absf( tonnes - who.tonnes )
	
	return 0.0


## convert lbs to g
static func pounds_to_grams( lbs: float ) -> float:
	return pounds_to_kilograms( lbs ) * metric_mult

## convert lbs to kg
static func pounds_to_kilograms( lbs: float ) -> float:
	return lbs / metric_to_pound_mult

## convert lbs to t
static func pounds_to_tonnes( lbs: float ) -> float:
	return pounds_to_kilograms( lbs ) / metric_mult


## convert g tp lbs
static func grams_to_pounds( g: float ) -> float:
	return kilograms_to_pounds( grams_to_kilograms( g ) )

## convert g to kg
static func grams_to_kilograms( g: float ) -> float:
	return g / metric_mult

## convert g to t
static func grams_to_tonnes( g: float ) -> float:
	return g / ( pow( metric_mult, 2 ) )


## convert kg to lbs
static func kilograms_to_pounds( kg: float ) -> float:
	return kg * metric_to_pound_mult

## convert kg to g
static func kilograms_to_grams( kg: float ) -> float:
	return kg * metric_mult

## convert kg to t
static func kilograms_to_tonnes( kg: float ) -> float:
	return kg / metric_mult


## convert t to lbs
static func tonnes_to_pounds( t: float ) -> float:
	return kilograms_to_pounds( tonnes_to_kilograms( t ) )

## convert t to g
static func tonnes_to_grams( t: float ) -> float:
	return t * ( pow( metric_mult, 2 ) )

## convert t to kg
static func tonnes_to_kilograms( t: float ) -> float:
	return t * metric_mult


## create a new [Mass] from a constant
static func from_const( index: COMMON_MARKS ) -> Mass:
	
	var mass := Mass.new()
	if ( index == COMMON_MARKS.HUMAN_WEIGHT ):
		mass.kilograms = 68.0
	elif ( index == COMMON_MARKS.STONE ):
		mass.pounds = 14.0
	return mass

## create a new [Mass] from a pound measurment
static func from_pounds( lbs: float ) -> Mass:
	
	var mass := Mass.new()
	mass.pounds = lbs
	return mass

## create a new [Mass] from a gram measurment
static func from_grams( g: float ) -> Mass:
	
	var mass := Mass.new()
	mass.grams = g
	return mass

## create a new [Mass] from a kilogram measurment
static func from_kilograms( kg: float ) -> Mass:
	
	var mass := Mass.new()
	mass.kilograms = kg
	return mass

## create a new [Mass] from a tonne measurment
static func from_tonnes( t: float ) -> Mass:
	
	var mass := Mass.new()
	mass.tonnes = t
	return mass
