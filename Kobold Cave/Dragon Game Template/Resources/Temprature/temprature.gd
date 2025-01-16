@icon( "res://Dragon Game Template/Icons/temperature.png" )
@tool
extends ScalieResource
class_name Temperature
## Class for heat
##
## this resource should provide everything you need to work with temperature.


@export_group( "Temperature" )
## heat in degrees kelvin
@export var kelvin: float = 0 : 
	set( value ):
		kelvin = value
		
		if ( _update_others ):
			_update_others = false
			
			celcius = kelvin_to_celcius( kelvin )
			rankine = kelvin_to_rankine( kelvin )
			fahrenheit = kelvin_to_fahrenheit( kelvin )
			
			_update_others = true
		
		heat_changed.emit( self )
## heat in degrees celcius
@export var celcius: float = 0 : 
	set( value ):
		celcius = value
		
		if ( _update_others ):
			_update_others = false
			
			kelvin = celcius_to_kelvin( celcius )
			rankine = celcius_to_rankine( celcius )
			fahrenheit = celcius_to_fahrenheit( celcius )
			
			_update_others = true
## heat in degrees absolute freedom
@export var rankine: float = 0 :
	set( value ):
		rankine = value
		
		if ( _update_others ):
			_update_others = false
			
			kelvin = rankine_to_kelvin( rankine )
			celcius = rankine_to_celcius( rankine )
			fahrenheit = rankine_to_fahrenheit( rankine )
			
			_update_others = true
## heat in degrees freedom
@export var fahrenheit: float = 0 : 
	set( value ):
		fahrenheit = value
		
		if ( _update_others ):
			_update_others = false
			
			celcius = fahrenheit_to_celcius( fahrenheit )
			kelvin = fahrenheit_to_kelvin( fahrenheit )
			rankine = fahrenheit_to_rankine( fahrenheit )
			
			_update_others = true


## this variable exists to prevent loops
var _update_others := true


## emited when the heat changes
signal heat_changed( heat: Temperature )


## const to help with c to k math
const kelvin_offset := -273.15
## const to help with f to r
const rankine_offset := -459.67
## const to help with c to f math
const fahrenheit_offset := 32.0
## const to help with absolutes
const absolute_mult := 1.8


## enum that stores common temperature related marks
enum COMMON_MARKS {
	ABSOLUTE_ZERO, ## Zero degrees kelvin, no energy exists
	WATER_FREEZES, ## zero degrees celcius, water is now ice
	ROOM_TEMP, ## 20c, all is normal
	BODY_TEMP, ## 38c, healthy body temprature
	WATER_BOILS, ## 100C, water is now steam
	
	_COUNT ## enum size
}

## enum for temperature scales
enum SCALE {
	K, ## kelvin
	C, ## celcius
	R, ## rankine
	F ## fahrenheit
	
}


func _to_string() -> String:
	
	const text := "\nTemperature\nKelvin: {0}\nCelcius: {1}\nRankine: {2}\nFahrenheit: {3}"
	return text.format( [ kelvin, celcius, rankine, fahrenheit ] )



## get the thermal difference between two [Temprature] objects
func get_diffrence( second_temp: Temperature, type: SCALE = SCALE.K ) -> float:
	
	if ( type == SCALE.K ):
		return absf( kelvin - second_temp.kelvin )
	elif ( type == SCALE.C ):
		return absf( celcius - second_temp.celcius )
	elif( type == SCALE.R ):
		return absf( rankine - second_temp.rankine )
	elif ( type == SCALE.F ):
		return absf( fahrenheit - second_temp.fahrenheit )
	
	return -1.0

## transfer heat using [Mass] objects
func transfer_heat( my_mass: Mass, second_heat: Temperature, second_mass: Mass, delta: float ) -> void: 
	
	print( "1: ", celcius, " 2: ", second_heat.celcius )
	
	# not enough mass
	if ( my_mass.grams < 1.0 or second_mass.grams < 1.0 ):
		return print( "not enough mass" )
	
	# get heat diff
	var heat_delta := get_diffrence( second_heat )
	if ( heat_delta < 1.0 ): # diff to low, save power
		return print( "not enough temp difference: ", heat_delta )
	
	# get conductivity
	var thermal_conductivity := minf( my_mass.thermal_conductivity, second_mass.thermal_conductivity )
	
	# this is how much energy we will transfer
	var heat_transfered := heat_delta * delta * thermal_conductivity * 1_000
	
	# the transfer
	if ( kelvin > second_heat.kelvin ):
		second_heat._suck_heat_from( second_mass, self, my_mass, heat_transfered )
	else:
		_suck_heat_from( my_mass, second_heat, second_mass, heat_transfered )
	
	print( "transfered: ", heat_transfered )
	
	pass

## p
func _suck_heat_from( my_mass: Mass, second_heat: Temperature, second_mass: Mass, heat_to_transfer: float ) -> void: 
	
	# suck heat
	second_heat.kelvin -= ( heat_to_transfer / second_mass.grams ) / second_mass.specific_heat_capacity
	
	# gain heat
	kelvin += ( heat_to_transfer / my_mass.grams ) / my_mass.specific_heat_capacity
	
	pass


## convert k to c
static func kelvin_to_celcius( k: float ) -> float:
	return k + kelvin_offset

## convert k to f
static func kelvin_to_fahrenheit( k: float ) -> float:
	const mult := 9.0/5.0
	
	return ( kelvin_to_celcius( k ) * mult ) + fahrenheit_offset

## convert k to r
static func kelvin_to_rankine( k: float ) -> float:
	return k * absolute_mult


## convert c to k
static func celcius_to_kelvin( c: float ) -> float:
	return c - kelvin_offset

## convert c to f
static func celcius_to_fahrenheit( c: float ) -> float:
	const mult := 9.0/5.0
	
	return ( c * mult ) + fahrenheit_offset

## convert c to r
static func celcius_to_rankine( c: float ) -> float:
	return kelvin_to_rankine( celcius_to_kelvin( c ) )


## convert r to k
static func rankine_to_kelvin( r: float ) -> float:
	return r / absolute_mult

## convert r to k
static func rankine_to_celcius( r: float ) -> float:
	return kelvin_to_celcius( rankine_to_kelvin( r ) )

## convert r to k
static func rankine_to_fahrenheit( r: float ) -> float:
	return kelvin_to_fahrenheit( rankine_to_kelvin( r ) )


## convert f to k
static func fahrenheit_to_kelvin( f: float ) -> float:
	const mult := 5.0/9.0
	
	return celcius_to_kelvin( ( f - fahrenheit_offset ) * mult )

## convert f to c
static func fahrenheit_to_celcius( f: float ) -> float:
	const mult := 5.0/9.0
	
	return ( f - fahrenheit_offset ) * mult

## convert f to r
static func fahrenheit_to_rankine( f: float ) -> float:
	return f + rankine_offset


## create a new [Temperature] resource from a enum
static func from_const( index: COMMON_MARKS ) -> Temperature:
	var temperature := Temperature.new()
	
	if ( index == COMMON_MARKS.ABSOLUTE_ZERO ):
		temperature.kelvin = 0.0
	elif ( index == COMMON_MARKS.WATER_FREEZES ):
		temperature.celcius = 0.0
	elif ( index == COMMON_MARKS.ROOM_TEMP ):
		temperature.celcius = 20.0
	elif ( index == COMMON_MARKS.BODY_TEMP ):
		temperature.celcius = 38.0
	elif ( index == COMMON_MARKS.WATER_BOILS ):
		temperature.celcius = 100.0
	
	return temperature

## create a new [Temperature] resource at a specific kelvin temperature
static func from_kelvin( k: float ) -> Temperature:
	
	var temp := Temperature.new()
	temp.kelvin = k
	return temp

## create a new [Temperature] resource at a specific celcius temperature
static func from_celcius( c: float ) -> Temperature:
	
	var temp := Temperature.new()
	temp.celcius = c
	return temp

## create a new [Temperature] resource at a specific rankine temperature
static func from_rankine( r: float ) -> Temperature:
	
	var temp := Temperature.new()
	temp.rankine = r
	return temp

## create a new [Temperature] resource at a specific fahrenheit temperature
static func from_fahrenheit( f: float ) -> Temperature:
	
	var temp := Temperature.new()
	temp.fahrenheit = f
	return temp
