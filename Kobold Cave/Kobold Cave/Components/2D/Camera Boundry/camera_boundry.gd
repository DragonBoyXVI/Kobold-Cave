@tool
extends Marker2D
class_name CameraBoundry
## used to dynamically set the bounds of teh camera during a level
##
## you can rename the node for quick set up,
## here are the names that work:[br]
## L, R, T, B, LT, LB, RT, RB, RESET


enum VERT_MODE {
	TOP,
	BOTTOM,
	
	RESET,
	NONE
}

enum HORZ_MODE {
	LEFT,
	RIGHT,
	
	RESET,
	NONE
}


## if true, the boundry is applied when the level starts
@export var tween_time: float = 0.25
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
	
	const reset_value := 10_000.0
	
	match vert_boundry:
		
		VERT_MODE.TOP:
			
			_tween_cam_limit( ^"limit_top", global_position.y )
		
		VERT_MODE.BOTTOM:
			
			_tween_cam_limit( ^"limit_bottom", global_position.y )
		
		VERT_MODE.RESET:
			
			_tween_cam_limit( ^"limit_bottom", reset_value )
			_tween_cam_limit( ^"limit_top", -reset_value )
	
	match horz_boundry:
		HORZ_MODE.LEFT:
			
			_tween_cam_limit( ^"limit_left", global_position.x )
		
		HORZ_MODE.RIGHT:
			
			_tween_cam_limit( ^"limit_right", global_position.x )
		
		HORZ_MODE.RESET:
			
			_tween_cam_limit( ^"limit_right", reset_value )
			_tween_cam_limit( ^"limit_left", -reset_value )


func _tween_cam_limit( limit: NodePath, value: float ) -> void:
	
	var tween := MainCamera2D.create_tween()
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	tween.set_ignore_time_scale()
	
	tween.tween_property( MainCamera2D, limit, value, tween_time )


var _name_update := true
func _util_on_renamed() -> void:
	
	if ( not _name_update ): 
		return
	_name_update = false
	
	
	const names_l := [ "l", "left" ]
	const names_r := [ "r", "right" ]
	const names_t := [ "t", "top", "up", "upper" ]
	const names_b := [ "b", "bottom", "down", "lower" ]
	const names_tl := [ "tl", "topleft", "lt", "lefttop" ]
	const names_tr := [ "tr", "topright", "rt", "righttop" ]
	const names_bl := [ "bl", "bottomleft", "lb", "leftbottom" ]
	const names_br := [ "br", "bottomright", "rb", "rightbottom" ]
	const names_reset := [ "reset" ]
	
	
	var my_name := name.to_lower()
	
	if ( names_l.has( my_name ) ):
		
		name = "CamLeft"
		horz_boundry = HORZ_MODE.LEFT
	elif ( names_r.has( my_name ) ): 
		
		name = "CamRight"
		horz_boundry = HORZ_MODE.RIGHT
	elif ( names_t.has( my_name ) ):
		
		name = "CamTop"
		vert_boundry = VERT_MODE.TOP
	elif ( names_b.has( my_name ) ):
		
		name = "CamBottom"
		vert_boundry = VERT_MODE.BOTTOM
	elif ( names_tl.has( my_name ) ): 
		
		name = "CamLeftTop"
		vert_boundry = VERT_MODE.TOP
		horz_boundry = HORZ_MODE.LEFT
	elif ( names_bl.has( my_name ) ): 
		
		name = "CamLeftBottom"
		vert_boundry = VERT_MODE.BOTTOM
		horz_boundry = HORZ_MODE.LEFT
	elif ( names_tr.has( my_name ) ): 
		
		name = "CamRightTop"
		vert_boundry = VERT_MODE.TOP
		horz_boundry = HORZ_MODE.RIGHT
	elif ( names_bl.has( my_name ) ): 
		
		name = "CamLeftBottom"
		vert_boundry = VERT_MODE.BOTTOM
		horz_boundry = HORZ_MODE.LEFT
	elif ( names_br.has( my_name ) ): 
		
		name = "CamRightBottom"
		vert_boundry = VERT_MODE.BOTTOM
		horz_boundry = HORZ_MODE.RIGHT
	elif ( names_reset.has( my_name ) ):
		
		name = "CamReset"
		vert_boundry = VERT_MODE.RESET
		horz_boundry = HORZ_MODE.RESET
	
	_name_update = true
