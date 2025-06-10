@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends RefCounted
class_name ExplosionParameters
## Used by the [ExplosionServer] to create explosions
##
## ditto


## the global coords of the explosion
var position: Vector2 = Vector2.ZERO
## the explosion radius in pixels
var radius: float = 144.0
## what percent of the radius is a normal deviation
var radius_deviation_percent: float = 0.05
## the damage object to supply
var damage: Damage = preload( "uid://b1l48xmw33mow" )
## How much push [CharacterBody2D]s are given
var push: float = 1200.0
## RIDs to ignore
var exclude: Array[ RID ] = []


var final_radius: float

func set_final_radius() -> void:
	
	final_radius = randfn( radius, radius * radius_deviation_percent )
