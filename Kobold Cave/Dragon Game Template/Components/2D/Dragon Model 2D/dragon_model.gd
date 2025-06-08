@icon( "res://Dragon Game Template/Icons/2D/dragon_model_2d.png" )
@tool
extends Node2D
class_name DragonModel2D
## idfk uh ill thinka somthin
##
## A model node meant to make animation easier
##
## A DragonModel seeks to make animation easier by seperating the model
## and the scene it's meant for.[br]
## DragonModels also provide several layers for animation,
## so the base scene can change the topmost color/rotation
## while the model worries about its own.[br]
## This creates a big divide between animation and events tied to it.

## The animation player this uses
@export var animation_player: AnimationPlayer : 
	set( new_player ):
		update_configuration_warnings.call_deferred()
		
		animation_player = new_player
		if ( root ): 
			
			animation_player.root_node = animation_player.get_path_to( root )
## The model container
@export var root: Node2D :
	set( new_root ):
		update_configuration_warnings.call_deferred()
		
		root = new_root
		if ( animation_player ):
			
			animation_player.root_node = animation_player.get_path_to( root )


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not animation_player ):
		
		const text := "No animation player to use."
		warnings.append( text )
	
	if ( not root ):
		
		const text := "The model has no root!"
		warnings.append( text )
	
	return warnings

func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered_tree )
		return 


var _color_tween: Tween
## Flashes the model with a color.[br]
## this affects the root node
func flash_color( color: Color, time: float = 0.125 ) -> void:
	
	# kill old tween
	if ( _color_tween ):
		_color_tween.kill()
	
	modulate = color
	var tween := root.create_tween()
	tween.set_trans( Tween.TRANS_LINEAR )
	tween.set_ease( Tween.EASE_IN )
	
	tween.tween_property( root, ^"modulate", Color.WHITE, time )
	
	_color_tween = tween


func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is AnimationPlayer and not animation_player ):
		
		animation_player = node
	elif ( node is Node2D and not root ):
		
		root = node
		node.name = &"Root"
