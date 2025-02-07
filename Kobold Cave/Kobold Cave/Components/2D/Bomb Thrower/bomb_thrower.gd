@tool
extends Node2D
class_name BombThrower
## used to throw bombas
##
## documentation


signal bomb_thrown


## if true, throw infinite bombs
@export var bomb_infinite: bool = false
## how many bombs you can throw
@export var bomb_max: int = 5
var bomb_amount: int = 5

## how far away to spawn the bomb, to prevent self collision
@export_range( 0.0, 125.0, 1.0, "or_greater" ) var throw_radius: float = 25.0 : 
	set( value ):
		queue_redraw()
		
		throw_radius = value


const bomb_scene := preload( "res://Kobold Cave/Bomb/bomb.tscn" ) as PackedScene
const throw_force := 800.0


func refill() -> void:
	
	bomb_amount = bomb_max

func throw_bomb( direction: Vector2 ) -> void:
	
	var spawn_position := global_position + ( direction * throw_radius )
	var spawn_velocity := direction * throw_force
	
	var bomb := bomb_scene.instantiate() as Bomb
	bomb.global_position = spawn_position
	bomb.velocity = spawn_velocity
	
	get_tree().current_scene.add_child( bomb )
	bomb_thrown.emit()


func _draw() -> void:
	
	if ( not Engine.is_editor_hint() ): return
	
	draw_circle( Vector2.ZERO, throw_radius, Color.RED, false )
