@icon( "res://Dragon Game Template/Icons/settings_file.png" )
extends Resource
class_name SettingsFile
## Dedicated resource for saving settings data
## 
## This resource saves all data related to settings.
## you may have to edit this again if you update to a new template.


# - Display
# window settings, visuals, frame rate, language, post process effects
# - Audio
# volumes, audio effect settings, tit titus free bird
# - Camera
# settings specific to the camera, like shaking or auto aim
# - Acessibility
# acessibility specific stuff, and repeat options from other tabs


## used for dummy settings
var dummy_property: Variant = 0.0


## test color settings
var pause_bg_color: Color = Color( 0, 0, 0, 0.2 )
## used for the black and white shader
var color_blind_enabled: bool = false


@export_group( "Game" )
## multiplier for ui animations
@export var ui_animation_speed: float = 1.0
## if this is true, the game pauses when the window loses focus
@export var pause_on_lost_focus: bool = true
## if this is true, [DragonMenu] tabs will reset when made visible
@export var menu_auto_reset: bool = true
## if true, right clicking will send a Backspace input event
#@export var overwrite_right_mb_as_back: bool = false
## if true, pressing crouch will make you crouch. press again to stand
@export var toggle_crouch: bool = false
## if set to 1, ui is placed on the bottom, 0 for the top
@export var ui_placement: int = 0

@export_group( "Display" )
## Game display fps, "_process"
@export var frame_rate: int = 30
## if true, sets the fps to be uncapped, or 0
@export var frame_rate_unlimited := false
## How often the physics engines step, "_physics_process"[br]
## i wouldnt blame you for hiding this one =p
@export var physics_rate: int = 60
## sets the physics interpolation variable in the [SceneTree]
@export var physics_interpolation := false
## First setting you have to refrence yourself[br]
## if true, particales should be shown.
@export var particles_enabled := true
## Sets the winow scaling mode. "No Scaling, Canvas, and Viewport"
@export var window_scaling: int = 1
## The mode of the window, doesn't change if you use the winow buttons to do stuff
@export var window_mode: Window.Mode = Window.MODE_WINDOWED

@export_group( "Camera" )
## The strength of camera shakes
@export var camera_shake_strength: float = 1.0
## set to true if the camera should process in physics steps.
## i think this one is broken...
@export var camera_as_physics: bool = false

@export_group( "Audio" )
## volume of the master bus
@export var volume_master: float = 1.0
## volume of the music bus
@export var volume_music: float = 0.8
## volume of the sfx bus
@export var volume_sfx: float = 1.0
## volume of the voice bus
@export var volume_voice: float = 1.0
## If false, music gets paused when the game pauses
@export var pause_music_when_paused := true

@export_group( "Accessibility" )
#@export var language: String
## the string passed to the [TranslationServer]
@export var translation: String = "en"
## check this yourself, if true flashing lights are used
@export var flashing_lights := true
## check this yourself, if true blood and gore are shown
@export var show_blood := true
## check this yourself, if true big boodie cock penis
@export var show_nudity := true


## returns the names of all exported settings variabless
func get_settings_names( filter := func( _item: Variant ) -> bool: return true ) -> PackedStringArray:
	
	var whitelist := PackedStringArray()
	whitelist.append( "dummy_property" )
	
	var properties := get_property_list()
	for property: Dictionary in properties:
		
		var property_name: String = property[ "name" ]
		if ( "resource" in property_name ): continue
		if ( property[ "type" ] == TYPE_NIL or property[ "type" ] == TYPE_OBJECT ): continue
		if ( property[ "usage" ] & ( PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SUBGROUP ) ):
			continue
		
		if ( not filter.call( property ) ): continue
		
		whitelist.append( property_name )
	
	return whitelist
