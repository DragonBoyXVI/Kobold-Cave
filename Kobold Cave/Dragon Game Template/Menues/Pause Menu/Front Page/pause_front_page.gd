extends MarginContainer


## emitted when the Settings button is pressed
signal settings_requested
## emitted when the main menu is requested
signal main_menu_requested
## emitted when the desktop is requested
signal desktop_requested
## emitted when the Debug menu button is pressed
signal debug_requested


## the button we want to focus when this is shown
@export var focus_button: BaseButton


func _ready() -> void:
	
	visibility_changed.connect( _on_visibility_changed, CONNECT_DEFERRED )

func _on_visibility_changed() -> void:
	
	if ( focus_button ):
		
		focus_button.grab_focus()


func _on_resume_button_pressed() -> void:
	
	var input := InputEventAction.new()
	input.action = &"Pause"
	input.pressed = true
	
	Input.parse_input_event( input )

func _on_settings_button_pressed() -> void:
	
	settings_requested.emit()

func _on_main_menu_button_pressed() -> void:
	
	main_menu_requested.emit()

func _on_desktop_button_pressed() -> void:
	
	desktop_requested.emit()

func _on_debug_button_pressed() -> void:
	
	debug_requested.emit()
