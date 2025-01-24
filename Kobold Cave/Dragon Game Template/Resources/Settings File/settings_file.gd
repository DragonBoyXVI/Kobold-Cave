@icon( "res://Dragon Game Template/Icons/settings_file.png" )
extends ScalieResource
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


var dummy_property: Variant = 0.0


# test color settings
var pause_bg_color: Color = Color( 0, 0, 0, 0.2 )
# used for the black and white shader
var color_blind_enabled: bool = false


@export_group( "Game" )
@export var pause_on_lost_focus: bool = true

@export var toggle_crouch: bool = true

@export_group( "Action Timers" )
@export var time_to_crouch: float = 0.1
@export var time_to_uncrouch: float = 0.1

@export var time_cyote: float = 0.15
@export var time_jump: float = 0.25

@export_group( "Display" )
@export var frame_rate: int = 30
@export var frame_rate_unlimited := false
@export var physics_rate: int = 30
@export var particles_enabled := true
@export var window_scaling: int = 1

@export_group( "Camera" )
@export var camera_shake_strength: float = 1.0
@export var camera_as_physics: bool = true

@export_group( "Audio" )
@export var volume_master: float = 1.0
@export var volume_music: float = 0.8
@export var volume_sfx: float = 1.0
@export var volume_voice: float = 1.0
@export var pause_music_when_paused := true

@export_group( "Accessibility" )
#@export var language: String
@export var translation: int = 0
@export var flashing_lights := true
@export var show_blood := true
@export var show_nudity := true
