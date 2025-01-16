@tool
extends Control


@export var tab_container: TabContainer :
	set( value ):
		update_configuration_warnings.call_deferred()
		
		tab_container = value


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	hide()
	process_mode = PROCESS_MODE_WHEN_PAUSED

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	DragonControler.tree_paused.connect( _on_paused, CONNECT_DEFERRED )
	
	Settings.loaded.connect( _on_settings_updated, CONNECT_DEFERRED )
	Settings.updated.connect( _on_settings_updated, CONNECT_DEFERRED )

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if ( not tab_container ):
		
		const text := "Please provide a TabContainer for this to manage"
		warnings.append( text )
	
	return warnings

func _input( event: InputEvent ) -> void:
	
	if ( event.is_action_pressed( &"Backspace" ) ):
		
		match tab_container.current_tab:
			
			0:
				
				pass
			
			_:
				
				tab_container.current_tab = 0
				accept_event()
		
		return


func _on_paused( paused: bool ) -> void:
	
	if ( paused ):
		
		tab_container.current_tab = 0
		show()
	else:
		
		Settings.save_data()
		Settings.update_all()
		
		hide()

func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	( %BGColor as ColorRect ).color = recived_data.pause_bg_color


func _on_pause_front_page_settings_requested() -> void:
	
	tab_container.current_tab = 1

func _on_pause_front_page_main_menu_requested() -> void:
	
	tab_container.current_tab = 2

func _on_pause_front_page_desktop_requested() -> void:
	
	tab_container.current_tab = 3

func _on_pause_front_page_debug_requested() -> void:
	
	tab_container.current_tab = 4


func _on_desktop_confirm_said_no() -> void:
	
	tab_container.current_tab = 0

func _on_main_menu_confirm_said_no() -> void:
	
	tab_container.current_tab = 0
