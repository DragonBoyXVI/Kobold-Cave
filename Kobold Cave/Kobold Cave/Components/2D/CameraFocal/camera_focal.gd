
extends Marker2D
class_name CameraFocal2D
## The camera looks at this
##
## ditto


func _ready() -> void:
	
	# deferred cause room changes cam state on ready
	MainCamera2D.set_follow_node.call_deferred( self )
	
	KoboldRadio.give_camera_to_player.connect( _on_radio_return_camera )

func _on_radio_return_camera() -> void:
	
	MainCamera2D.set_follow_node( self )
