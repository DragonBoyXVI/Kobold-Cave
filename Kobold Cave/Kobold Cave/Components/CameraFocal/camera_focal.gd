
extends Marker2D
class_name CameraFocal2D
## The camera looks at this
##
## ditto


func _ready() -> void:
	
	MainCamera2D.set_state_follow_node( self )
