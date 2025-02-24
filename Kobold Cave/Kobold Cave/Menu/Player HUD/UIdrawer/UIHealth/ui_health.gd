@tool
extends UIDrawer
class_name UIHealth
## draws hp pips
##
## ditto


var health: Health


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.ui_connect_health.connect( _on_radio_ui_connect_health )

func _draw_pip( pos: Vector2 ) -> void:
	
	draw_circle( pos, 28.0, Color.RED )


func _on_radio_ui_connect_health( new_health: Health ) -> void:
	
	if ( new_health.updated.is_connected( _on_health_updated ) ):
		return
	
	if ( health ):
		
		health.updated.disconnect( _on_health_updated )
	new_health.updated.connect( _on_health_updated )
	
	health = new_health
	_on_health_updated.call_deferred()

func _on_health_updated() -> void:
	
	pip_amount = ceili( health.current )
