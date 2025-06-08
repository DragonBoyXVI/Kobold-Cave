@icon( "res://Dragon Game Template/Icons/3D/hitbox_3d.png" )
extends Area3D
class_name ObjHitbox3D
## A node that can get hit by [ObjHurtbox3D] and send info
##
## ditto


## emitted when this is enabled
signal enabled
## emitted when this is disabled
signal disabled
## emitted when this gets an event from a hurtbox,
## before sending it to the [NodeHealth]
signal recived_event( event: HurtboxEvent )


## the team mask we use. If empty, all hurtboxes hit this.
@export var team_mask: TeamMask


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
