@icon( "res://Dragon Game Template/Icons/3D/hurtbox_3d.png" )
@tool
extends Area3D
class_name Hurtbox3D
## Searches for [Hitbox3D] nodes and pushes an event to any it hits.
##
## Uses an area to detect hitbox areas, and send a duplicate
## event to them.


## emitted before the hurtbox sends the data.
signal pre_send( event: HurtboxEvent )

## emitted when this is enabled
signal enabled
## emitted when this is disabled
signal disabled


## Lets you add hitboxes that this should always ignore
@export var exclude: Array[ Hitbox3D ] = []
## the team mask this uses. If empty, this hits all hitboxes.
@export var team_mask: TeamMask
## the event this hurtbox will supply
@export var event: HurtboxEvent :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		event = value


func _ready() -> void:
	
	area_entered.connect( _on_area_entered )

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not event ):
		
		const text := "Without an event, this hurtbox wont interact with hitboxes."
		warnings.append( text )
	
	return warnings


## used to determine if we can hit this hitbox
func is_hitbox_valid( hitbox: Hitbox3D ) -> bool:
	
	# exit if on the same team
	if ( team_mask and hitbox.team_mask ):
		
		if ( not team_mask.does_hit_team( hitbox.team_mask ) ):
			
			return false
	
	if ( exclude.has( hitbox ) ):
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
func _is_hitbox_valid( _hitbox: Hitbox3D ) -> bool:
	
	return true


func _on_area_entered( area: Area3D ) -> void:
	
	if ( not event ): return
	
	if ( area is Hitbox3D ):
		var hitbox := area as Hitbox3D
		
		if ( is_hitbox_valid( hitbox ) ):
			
			var sendable_event := event.duplicate()
			pre_send.emit( sendable_event )
			
			hitbox.hit( sendable_event )
