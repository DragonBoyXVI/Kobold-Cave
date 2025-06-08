@icon( "res://Dragon Game Template/Icons/2D/hurtbox_2d.png" )
@tool
extends Area2D
class_name ObjHurtbox2D
## Searches for [ObjHitbox2D] nodes and pushes an event to any it hits.
##
## Uses an area to detect hitbox areas, and send a duplicate
## event to them.


## emitted before the hurtbox sends the data.
signal pre_send( event: HurtboxEvent )

## emitted when this is enabled
signal enabled
## emitted when this is disabled
signal disabled


## Lets you add hitboxes that this should alwa
## the team mask this uses. If empty, this hits all hitboxes.
@export var team_mask: TeamMask
## the event this hurtbox will supply
@export var event: HurtboxEvent :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		event = value


const SHAPE_COLOR: Color = Color( 1.0, 0.0, 0.0, 0.4 )


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return
	
	area_entered.connect( _on_area_entered )

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not event ):
		
		const text := "Without an event, this hurtbox wont interact with hitboxes."
		warnings.append( text )
	
	return warnings


## used to determine if we can hit this hitbox
func is_hitbox_valid( hitbox: ObjHitbox2D ) -> bool:
	
	# exit if on the same team
	if ( team_mask and hitbox.team_mask ):
		
		if ( not team_mask.does_hit_team( hitbox.team_mask ) ):
			
			return false
	
	# this could be expensive, so we do it last
	if ( not _is_hitbox_valid( hitbox ) ):
		return false
	
	return true

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


## virtual for how to disable this
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual for how to disable this
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED

## virtual for extra conditions you wish to check when validating
## a hitbox
func _is_hitbox_valid( _hitbox: ObjHitbox2D ) -> bool:
	
	return true


func _on_area_entered( area: Area2D ) -> void:
	
	if ( not event ): return
	
	if ( area is ObjHitbox2D ):
		var hitbox: ObjHitbox2D = area
		
		if ( is_hitbox_valid( hitbox ) ):
			
			var sendable_event := event.duplicate()
			pre_send.emit( sendable_event )
			
			hitbox.hit( sendable_event )


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		
		node.debug_color = SHAPE_COLOR
