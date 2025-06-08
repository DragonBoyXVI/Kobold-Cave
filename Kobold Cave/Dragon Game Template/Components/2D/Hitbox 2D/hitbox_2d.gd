@icon( "res://Dragon Game Template/Icons/2D/hitbox_2d.png" )
@tool
extends Area2D
class_name ObjHitbox2D
## A node that can get hit by [ObjHurtbox2D] and send info to a
## [NodeHealth].
##
## Simply sends the data to all connected [NodeHealth]s and doesn't
## touch the passed data.


## emitted when this is enabled
signal enabled
## emitted when this is disabled
signal disabled
## emitted when this gets an event from a hurtbox
signal recived_event( event: HurtboxEvent )

## the team mask we use. If empty, all hurtboxes hit this.
@export var team_mask: TeamMask


const SHAPE_COLOR: Color = Color( 0.0, 0.0, 1.0, 0.4 )


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return


## used to enable the hitbox
func enable() -> void:
	
	_enable()
	show()
	enabled.emit()

## used to disable the hitbox
func disable() -> void:
	
	_disable()
	hide()
	disabled.emit()

## called by a hurtbox when it hits this
func hit( event: HurtboxEvent ) -> void:
	
	_hit( event )
	recived_event.emit( event )


## virtual for how to disable this
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual for how to disable this
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED

## virtual for what happens to the event before it is sent
## to all connected health nodes.
func _hit( _event: HurtboxEvent ) -> void:
	pass



func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = SHAPE_COLOR
