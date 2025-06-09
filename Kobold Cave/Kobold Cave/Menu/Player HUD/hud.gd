@tool
extends Control
class_name HUD
## displays health and bomb count
##
## ditto

const corner_offset_amount: float = 5.0
const corner_offset_direction: PackedVector2Array = [
	Vector2( 1.0, 1.0 ),
	Vector2( -1.0, 1.0 ),
	Vector2( 1.0, -1.0 ),
	Vector2( -1.0, -1.0 )
]
enum CORNERS {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}


var _ui_placement: int = -1


@export var health_ui: UIHealth
@export var bomb_ui: UIBombs


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_on_child_entered_tree )
		return
	
	Settings.connect_changed_callback( _on_settings_updated )


func place_ui( new_place: int ) -> void:
	
	if ( new_place < 0 or new_place == _ui_placement ):
		return
	_ui_placement = new_place
	
	match new_place:
		0:
			
			move_thing( health_ui, CORNERS.TOP_LEFT )
			move_thing( bomb_ui, CORNERS.TOP_RIGHT )
		
		1:
			
			move_thing( health_ui, CORNERS.BOTTOM_LEFT )
			move_thing( bomb_ui, CORNERS.BOTTOM_RIGHT )

func move_thing( thing: Control, corner: CORNERS ) -> void:
	
	var new_position := Vector2.ZERO
	var new_scale := Vector2.ONE
	match corner:
		CORNERS.TOP_LEFT:
			
			pass
		CORNERS.TOP_RIGHT:
			
			new_position.x += size.x
			new_scale.x = -1.0
		CORNERS.BOTTOM_LEFT:
			
			new_position.y += size.y
			new_scale.y = -1.0
		CORNERS.BOTTOM_RIGHT:
			
			new_position += size
			new_scale *= -1.0
	
	
	var tween := create_tween()
	tween.set_parallel()
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS )
	
	const time := 0.1
	tween.tween_property( thing, ^"position", new_position, time )
	tween.tween_property( thing, ^"scale", new_scale, time )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	place_ui( recived_data.ui_placement )

func _util_on_child_entered_tree( node: Node ) -> void:
	
	if ( node is UIHealth and not health_ui ):
		
		health_ui = node
	elif( node is UIBombs and not bomb_ui ):
		
		bomb_ui = node
