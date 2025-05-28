
extends Control


@export var focus_me: Control

var active := false


func _ready() -> void:
	
	hide()
	
	DragonControler.tree_paused.connect( _on_tree_paused )
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched, CONNECT_DEFERRED )


func _on_tree_paused( paused: bool ) -> void:
	
	if ( active and not paused ):
		
		# ???
		await get_tree().process_frame
		focus_me.grab_focus.call_deferred()

func _on_radio_goal_touched() -> void:
	
	active = true
	show()
	focus_me.grab_focus.call_deferred()


func _on_next_button_pressed() -> void:
	
	hide()
	active = false
	GameManager.advance()
