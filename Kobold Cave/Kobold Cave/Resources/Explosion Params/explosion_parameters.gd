@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends RefCounted
class_name ExplosionParameters
## Used by the [ExplosionServer] to create explosions
##
## ditto


## the global coords of the explosion
var position: Vector2 = Vector2.ZERO
## the explosion radius in pixels
var radius: float = 144.0 :
	set( val ):
		
		radius = val
		radius_squared = pow( val, 2.0 )
## the radius squared
var radius_squared: float = pow( radius, 2.0 )
## the damage object to supply
var damage: Damage = preload( "uid://drko8psvy2smv" )
## How much push [CharacterBody2D]s are given
var push: float = 1200.0
## RIDs to ignore
var exclude: Array[ RID ] = []
