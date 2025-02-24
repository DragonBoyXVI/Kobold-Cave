@tool
extends Panel
class_name UIDrawer
## shows health pips
##
## ditto


@export_custom( PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR ) var pip_amount: int = 5:
	set( value ):
		pip_amount = value
		queue_redraw()
var panel_length: int = 1


const pips_per_line: int = 5
const pip_spacing: Vector2 = Vector2( 64.0, 64.0 )
const pip_init_offset: Vector2 = Vector2( 32.0, 32.0 )


func _draw() -> void:
	
	var current_position := pip_init_offset
	for i: int in pip_amount:
		
		_draw_pip( current_position )
		
		if ( i > 0 and ( i + 1 ) % 5 == 0  ):
			
			current_position.x = pip_init_offset.x
			current_position.y += pip_spacing.y
		else:
			
			current_position.x += pip_spacing.x
	
	var new_panel_length: int = ceili( pip_amount / 5.0 )
	if ( panel_length != new_panel_length ):
		panel_length = new_panel_length
		
		var tween := create_tween()
		tween.set_parallel()
		tween.set_trans( Tween.TRANS_ELASTIC )
		tween.set_ease( Tween.EASE_OUT )
		
		const time := 0.5
		tween.tween_property( self, ^"size:y", 64.0 * panel_length, time )
		if ( panel_length <= 0 ):
			
			tween.tween_property( self, ^"modulate:a", 0.0, time )
		else:
			
			tween.tween_property( self, ^"modulate:a", 1.0, time )

func _draw_pip( pos: Vector2 ) -> void:
	
	draw_circle( pos, 32.0, Color.GREEN, false )
