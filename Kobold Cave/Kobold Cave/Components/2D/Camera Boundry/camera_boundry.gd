@tool
extends Marker2D
class_name CameraBoundry
## used to dynamically set the bounds of teh camera during a level
##
## you can rename the node for quick set up,
## here are the names that work:[br]
## L, R, T, B, LT, LB, RT, RB


enum VERT_MODE {
	TOP,
	BOTTOM,
	
	NONE
}

enum HORZ_MODE {
	LEFT,
	RIGHT,
	
	NONE
}


## if true, the boundry is applied when the level starts
@export var auto_activate: bool = false
@export var vert_boundry := VERT_MODE.NONE : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		vert_boundry = value
@export var horz_boundry := HORZ_MODE.NONE : 
	set( value ):
		update_configuration_warnings.call_deferred()
		
		horz_boundry = value


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( vert_boundry == VERT_MODE.NONE and horz_boundry == HORZ_MODE.NONE ):
		
		const text := "Horizonal and Vertical modes are disabled, boundry will have no effect."
		warnings.append( text )
	
	return warnings

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		renamed.connect( _util_on_renamed )
		return
	
	if ( auto_activate ):
		
		activate()


func activate() -> void:
	
	match vert_boundry:
		
		VERT_MODE.TOP:
			
			_tween_cam_limit( ^"limit_top", global_position.y )
		
		VERT_MODE.BOTTOM:
			
			_tween_cam_limit( ^"limit_bottom", global_position.y )
	
	match horz_boundry:
		HORZ_MODE.LEFT:
			
			_tween_cam_limit( ^"limit_left", global_position.x )
		
		HORZ_MODE.RIGHT:
			
			_tween_cam_limit( ^"limit_right", global_position.x )


func _tween_cam_limit( limit: NodePath, value: float ) -> void:
	
	var tween := KoboldUtility.create_tween_style( MainCamera2D )
	
	tween.tween_property( MainCamera2D, limit, value, 1.25 )


var _name_update := true
func _util_on_renamed() -> void:
	
	if ( not _name_update ): 
		return
	_name_update = false
	
	var my_name := name.to_lower()
	match my_name:
		
		"l": 
			name = "CamLeft"
			horz_boundry = HORZ_MODE.LEFT
		
		"r": 
			name = "CamRight"
			horz_boundry = HORZ_MODE.RIGHT
		
		"t": 
			name = "CamTop"
			vert_boundry = VERT_MODE.TOP
		
		"b": 
			name = "CamBottom"
			vert_boundry = VERT_MODE.BOTTOM
		
		"lt": 
			name = "CamLeftTop"
			vert_boundry = VERT_MODE.TOP
			horz_boundry = HORZ_MODE.LEFT
		
		"lb": 
			name = "CamLeftBottom"
			vert_boundry = VERT_MODE.BOTTOM
			horz_boundry = HORZ_MODE.LEFT
		
		"rt": 
			name = "CamRightTop"
			vert_boundry = VERT_MODE.TOP
			horz_boundry = HORZ_MODE.RIGHT
		
		"rb": 
			name = "CamLeftBottom"
			vert_boundry = VERT_MODE.BOTTOM
			horz_boundry = HORZ_MODE.RIGHT
	
	
	_name_update = true
