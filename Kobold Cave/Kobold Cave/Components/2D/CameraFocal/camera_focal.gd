
extends Marker2D
class_name CameraFocal2D
## The camera looks at this
##
## ditto


func _ready() -> void:
	
	# deferred cause room changes cam state on ready
	MainCamera2D.set_follow_node.call_deferred( self )
