extends Node
@warning_ignore_start( "unused_signal" )
## global signals for DragonTemplate use
## i would use another radio for your own game use.


## here so non node scripts can access the 2d world
var access_2d: Node2D
## here so non node scripts can access the 3d world
var access_3d: Node3D


func _init() -> void:
	
	access_2d = Node2D.new()
	access_3d = Node3D.new()
	
	add_child( access_2d )
	add_child( access_3d )
	
	process_mode = Node.PROCESS_MODE_DISABLED
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED


## emmited when widgets want to sync data
signal widget_sync( property: StringName, value: Variant )


## emitted when the user wishes to return to the main menu
signal main_menu_requested

## When get_tree().quit() is called, must emit yourself
signal tree_quited


## emitted when something wants text on a description box
signal description_display_me( provided_text: String, provided_password: StringName )


#region Settings

signal settings_changed_ticks( new_file: SettingsFile )
signal settings_changed_window( new_file: SettingsFile )
signal settings_changed_audio( new_file: SettingsFile )
## [Node] also has a TRANSLATION_CHANGED notifictation that
## may be better suited for this task
signal settings_changed_translation( new_file: SettingsFile )
signal settings_changed_camera( new_file: SettingsFile )
signal settings_changed( new_file: SettingsFile )

#endregion

#region Pauser

## emitted when [DragonPause] toggles the pause state[br]
## argument is true if the tree is paused
signal pause_toggled( is_paused: bool )

#endregion

#region TimeControl

## emitted when th time scale is changed using [TimeControl]
signal time_scale_changed( new_scale: float, type: TimeControl.CHANGE_TYPE )

#endregion

#region MenuServer

## emitted when a menu is created
signal menu_created( menu: DragonMenu )

#endregion
