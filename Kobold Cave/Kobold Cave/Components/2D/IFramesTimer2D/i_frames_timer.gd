@tool
extends Timer
class_name IFramesTimer
## Disables a [Hurtbox2D] when a [NodeHealth] takes [Damage]
##
## Ditto

## profile used to trigger this.
## changing this at runtime does nothing
@export var profile: DamageProfile:
	set( new ):
		
		profile = new
		update_configuration_warnings()
## hitbox to disable
@export var hitbox: ObjHitbox2D:
	set( new ):
		
		hitbox = new
		update_configuration_warnings()
## visual component to animate
@export var visual_node: Node2D


static var _flashing_lights: bool = true

var _tween: Tween


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not profile ):
		
		const text := "Needs a profile to function"
		warnings.append( text )
	
	if ( not hitbox ):
		
		const text := "Needs a hitbox node to function"
		warnings.append( text )
	
	return warnings

static func _static_init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	Settings.connect_changed_callback( _on_static_settings_updated )

func _init() -> void:
	
	process_callback = Timer.TIMER_PROCESS_PHYSICS
	one_shot = true
	
	if ( Engine.is_editor_hint() ):
		return
	
	timeout.connect( _on_timeout )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	profile.took_damage.connect( _on_profile_took_damage )


func _on_profile_took_damage( _damage: Damage ) -> void:
	
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


static func _on_static_settings_updated( recived_data: SettingsFile ) -> void:
	
	_flashing_lights = recived_data.flashing_lights
