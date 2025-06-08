@tool
extends CameraEffect2D
class_name CameraShake2D
## a [CameraEffect2D] that shakes the screen.
## 
## This effect makes the camera shake around. Best to add a setting
## that turns this off or reduces the strength of it.


@export_group( "Shake", "shake_" )
## How strong the shake is.
## eg. how many pixels the offset will be
@export_range( 0.0, 125.0, 0.01, "or_greater" ) var shake_strength: float = 25.0
## A curve that effects strength over time.
## has no effect if the effect duration is unlimited.
var shake_curve: Curve


static var _setting_shake_strength: float = 1.0

static func _static_init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	# kill race condition
	await Engine.get_main_loop().physics_frame
	Settings.connect_changed_callback( _on_settings_updated )

static func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_setting_shake_strength = recived_data.camera_shake_strength


func _init() -> void:
	
	# default linear curve
	if ( not shake_curve ):
		
		shake_curve = Curve.new()
		shake_curve.add_point( Vector2( 1.0, 0.0 ), 0.0, 0.0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )
		shake_curve.add_point( Vector2( 0.0, 1.0 ), 0.0, 0.0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR )

func _get_property_list() -> Array[ Dictionary ]:
	var properties: Array[ Dictionary ] = []
	
	if ( duration_mode == DURATION_MODE.LIMITED ):
		
		properties.append( {
			"name": "shake_curve",
			"type": TYPE_OBJECT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "Curve"
		} )
	
	return properties

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"shake_curve",
		"shake_strength"
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		
		&"shake_curve": return null
		&"shake_strength": return 25.0
	
	return null


func _update( cam: Camera2D, _delta: float ) -> void:
	
	if ( _setting_shake_strength <= 0.0 ): return
	
	# get curve factor
	var curve_factor := 1.0
	if ( shake_curve ):
		
		curve_factor = shake_curve.sample_baked( duration_percent )
	
	# get shake vector
	const circle_degrees := deg_to_rad( 360.0 )
	var shake_vector := Vector2.from_angle( randf() * circle_degrees )
	shake_vector *= shake_strength * curve_factor * _setting_shake_strength
	
	# apply
	cam.offset = shake_vector

func _remove( cam: Camera2D ) -> void:
	
	cam.offset = Vector2.ZERO
