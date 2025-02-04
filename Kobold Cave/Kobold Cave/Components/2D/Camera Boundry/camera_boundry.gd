@tool
extends Marker2D
class_name CameraBoundry


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
@export var vert_boundry := VERT_MODE.NONE
@export var horz_boundry := HORZ_MODE.NONE

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		renamed.connect( _util_on_renamed )
		return
	
	if ( auto_activate ):
		
		activate()


func activate() -> void:
	pass


var _name_update := true
func _util_on_renamed() -> void:
	
	if ( not _name_update ): 
		
		_name_update = true
		return
	
	var my_name := name.to_lower()
	
	#region constants
	
	const names_bottom: PackedStringArray = [
		"bottom",
		"boundbottom",
		"cambottom"
	]
	const name_final_bottom := "CamBoundBottom"
	
	#endregion constants
