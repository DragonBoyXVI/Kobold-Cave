@icon( "res://Dragon Game Template/Icons/2D/dragon_model_2d.png" )
extends Node2D
class_name DragonModel2D
## A model node meant to make animation easier
##
## A DragonModel seeks to make animation easier by seperating the model
## and the scene it's meant for.[br]
## DragonModels also provide several layers for animation,
## so the base scene can change the topmost color/rotation
## while the model worries about its own.[br]
## This creates a big divide between animation and events tied to it.

## The animation player this uses
@onready var animation_player := ( %AnimationPlayer as AnimationPlayer )
## The model container
@onready var root := ( %Root as Node2D )


var _color_tween: Tween
## Flashes the model with a color.[br]
## this affects the [DragonModel2D] node, not the root
func flash_color( color: Color, time: float = 0.125 ) -> void:
	
	# kill old tween
	if ( _color_tween ):
		_color_tween.kill()
	
	modulate = color
	var tween := create_tween()
	tween.set_trans( Tween.TRANS_LINEAR )
	tween.set_ease( Tween.EASE_IN )
	
	tween.tween_property( self, ^"modulate", Color.WHITE, time )
	
	_color_tween = tween
