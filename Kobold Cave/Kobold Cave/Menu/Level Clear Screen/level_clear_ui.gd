
extends Control


@export var pb_container: PanelContainer
@export var pb_record_label: Label
@export var pb_time_label: Label
@export var current_time_label: Label

var active := false


@export var pb_panel_normal: StyleBox
@export var pb_panel_best: StyleBox



func _ready() -> void:
	
	hide()
	
	#StopWatch.stopped.connect( _on_stop_watch_stopped )
	KoboldRadio.goal_touched.connect( _on_radio_goal_touched )
	KoboldRadio.ui_display_time.connect( _on_radio_ui_show_time )


func set_pb_panel( panel: StyleBox ) -> void:
	
	pb_container.add_theme_stylebox_override( &"panel", panel )


func _on_radio_ui_show_time( level_id: SaveFile.LEVEL, was_best: bool ) -> void:
	
	current_time_label.text = StopWatch.time_to_string( StopWatch.elapsed_time )
	
	if ( was_best ):
		
		pb_record_label.show()
		set_pb_panel( pb_panel_best )
		pb_time_label.text = StopWatch.time_to_string( StopWatch.elapsed_time )
	else:
		
		pb_record_label.hide()
		set_pb_panel( pb_panel_normal )
		pb_time_label.text = StopWatch.time_to_string( SaveGameManager.current_file.level_get_time( level_id ) )

func _on_radio_goal_touched() -> void:
	
	active = true
	show()
	modulate.a = 0.0
	DragonUIAnimations.fade_control( self, true )

func _on_next_button_pressed() -> void:
	
	hide()
	active = false
	GameManager.advance()
