@tool
extends UIDrawer
class_name UIBombs
## draws your bombs
##
## ditto


var bomb_thrower: BombThrower


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	KoboldRadio.ui_connect_bombs.connect( _on_radio_ui_connect_bombs )

func _draw_pip( pos: Vector2 ) -> void:
	
	const rect_size := Vector2( 56.0, 56.0 )
	var rect := Rect2( ( pos - ( rect_size / 2 ) ), rect_size )
	draw_rect( rect, Color.BLACK )


func _on_radio_ui_connect_bombs( new_thrower: BombThrower ) -> void:
	
	bomb_thrower = new_thrower
	bomb_thrower.updated.connect( _on_bomb_thrower_update )
	_on_bomb_thrower_update.call_deferred()

func _on_bomb_thrower_update() -> void:
	
	pip_amount = bomb_thrower.bomb_amount
