@tool
extends Timer
class_name IFramesTimer
## Disables a [Hurtbox2D] when a [NodeHealth] takes [Damage]
##
## Ditto

## health node used to trigger this.
## changing this at runtime does nothing
@export var health_node: NodeHealth:
	set( new ):
		
		health_node = new
		update_configuration_warnings()
## hitbox to disable
@export var hitbox: Hitbox2D:
	set( new ):
		
		hitbox = new
		update_configuration_warnings()
## visual component to animate
@export var visual_node: Node2D


var _flashing_lights: bool = true
var _tween: Tween


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not health_node ):
		
		const text := "Needs a health node to function"
		warnings.append( text )
	
	if ( not hitbox ):
		
		const text := "Needs a hitbox node to function"
		warnings.append( text )
	
	return warnings

func _init() -> void:
	
	process_callback = Timer.TIMER_PROCESS_PHYSICS
	one_shot = true
	
	if ( Engine.is_editor_hint() ):
		return
	
	timeout.connect( _on_timeout )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	if ( not health_node.is_node_ready() ):
		await health_node.ready
	health_node.hurt.connect( _on_health_node_hurt )
	
	if ( Settings.data ):
		_on_settings_updated( Settings.data )
	Settings.updated.connect( _on_settings_updated )


func _on_health_node_hurt( _damage: Damage ) -> void:
	
	hitbox.disable.call_deferred()
	start()
	
	if ( not visual_node ): return
	if ( _tween ):
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_ignore_time_scale()
	_tween.set_loops()
	
	if ( _flashing_lights ):
		
		_tween.tween_callback( visual_node.hide ).set_delay( 0.125 )
		_tween.tween_callback( visual_node.show ).set_delay( 0.125 )
	else:
		
		_tween.tween_property( visual_node, ^"modulate", Color.TRANSPARENT, 0.250 )
		_tween.tween_property( visual_node, ^"modulate", Color.WHITE, 0.250 )

func _on_timeout() -> void:
	
	hitbox.enable.call_deferred()
	
	if ( _tween ):
		
		_tween.kill()
		_tween = null
	
	if ( not visual_node ): return
	visual_node.modulate = Color.WHITE
	visual_node.show()


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_flashing_lights = recived_data.flashing_lights
