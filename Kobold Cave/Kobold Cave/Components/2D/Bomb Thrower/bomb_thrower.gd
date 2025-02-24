@tool
extends Node2D
class_name BombThrower
## used to throw bombas
##
## documentation


signal bomb_thrown


## if true, throw infinite bombs
@export var bomb_infinite: bool = false
## if true, start with no bombs
@export var starts_empty := false
## how many bombs you can throw
@export var bomb_max: int = 5
var bomb_amount: int = 5

## how far away to spawn the bomb, to prevent self collision
@export_range( 0.0, 125.0, 1.0, "or_greater" ) var throw_radius: float = 25.0 : 
	set( value ):
		queue_redraw()
		
		throw_radius = value


## use to limit how quickly bombs can be thrown
@export var cooldown_timer: Timer


const bomb_scene := preload( "res://Kobold Cave/Bomb/bomb.tscn" ) as PackedScene
const throw_force := 800.0


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return
	
	if ( starts_empty ):
		
		bomb_amount = 0

func _draw() -> void:
	
	if ( not Engine.is_editor_hint() ): return
	
	draw_circle( Vector2.ZERO, throw_radius, Color.RED, false )


func refill() -> void:
	
	bomb_amount = bomb_max

func throw_bomb( direction: Vector2, initial_velocity := Vector2.ZERO ) -> void:
	
	if ( cooldown_timer ):
		
		if ( cooldown_timer.is_stopped() ):
			
			cooldown_timer.start()
		else:
			
			return
	
	if ( not bomb_infinite ):
		
		if ( bomb_amount > 0 ):
			
			bomb_amount -= 1
		else:
			
			return
	
	var spawn_position := global_position + ( direction * throw_radius )
	var spawn_velocity := ( direction * throw_force ) + initial_velocity
	
	var bomb := bomb_scene.instantiate() as Bomb
	bomb.global_position = spawn_position
	bomb.velocity = spawn_velocity
	
	get_tree().current_scene.add_child( bomb )
	bomb_thrown.emit()


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is Timer and not cooldown_timer ):
		
		cooldown_timer = node
