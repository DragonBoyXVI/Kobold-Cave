@icon( "res://Dragon Game Template/Icons/scalie_resource.png" )
extends Resource
class_name ParticleOptions
## Resource that is loaded by the particle manager
##
## Gets loaded into the particle manager from the disk,
## and used as a key when spawning particles


## the scene the particles are instanciated from
@export var packed_scene: PackedScene

## how many to spawn at game start
@export_range( 0, 25, 1, "or_greater" ) var initial_scene_count: int = 5
## when to start freeing nodes
@export_range( 0, 25, 1, "or_greater" ) var ideal_count: int = 15
