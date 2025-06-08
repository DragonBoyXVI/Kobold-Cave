@tool
extends TabContainer
class_name DragonMenu
## Placeholder
##
## ditto


## the keys used to translate tab names
@export var tab_translation_keys: PackedStringArray = []


## if true, this node's tabs will grab focus when this 
## becomes visible[br]
## consider turning this off if a child node grabs focus instead
@export var auto_focus: bool = false
## When this becomes visible, it'll automatically
## switch to this tab. is also does this on ready
@export var initial_tab: int = 0:
	set( new ):
		
		initial_tab = clampi( new, 0, get_tab_count() )


## if true, a child node of this has focus
var child_has_focus: bool = false
## child node that has focus
var focused_child: Control


## the current translation this box is using
var _current_translation: String = "en"

## if true, menues made visible will show their first initial tab
static var _auto_reset: bool


static func _static_init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	Settings.connect_changed_callback( _on_static_settings_update )

func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	focus_entered.connect( grab_tab_bar_focus, CONNECT_DEFERRED )
	visibility_changed.connect( _on_visibility_changed )

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	get_window().gui_focus_changed.connect( _on_window_gui_focus_changed )
	current_tab = initial_tab
	
	#Settings.connect_changed_callback( _on_settings_update, 0, Settings.UPDATE.TRANSLATION )
	
	_on_visibility_changed()
	_on_window_gui_focus_changed( get_window().gui_get_focus_owner() )

func _input( event: InputEvent ) -> void:
	
	if ( not child_has_focus ): return
	if ( get_tab_count() <= 1 ): return
	if ( not tabs_visible ): return
	#if ( not is_visible_in_tree() ): return
	
	if ( event.is_action_pressed( &"Menu Tab Left" ) ):
		
		current_tab = wrapi( current_tab - 1, 0, get_tab_count() )
		grab_tab_bar_focus.call_deferred()
		
		accept_event()
		return
	
	if ( event.is_action_pressed( &"Menu Tab Right" ) ):
		
		current_tab = wrapi( current_tab + 1, 0, get_tab_count() )
		grab_tab_bar_focus.call_deferred()
		
		accept_event()
		return

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_TRANSLATION_CHANGED:
			
			if ( Engine.is_editor_hint() ):
				return
			
			if ( not is_node_ready() ):
				await ready
			
			set_tabs_translation()
		
		NOTIFICATION_PAUSED:
			
			if ( Engine.is_editor_hint() ):
				return
			
			DragonUIAnimations.fade_control( self, false )
		
		NOTIFICATION_UNPAUSED:
			
			if ( Engine.is_editor_hint() ):
				return
			
			DragonUIAnimations.fade_control( self, true )
			
			if ( child_has_focus ):
				
				if ( focused_child ):
					
					focused_child.grab_focus.call_deferred()
				else:
					
					grab_tab_bar_focus.call_deferred()


## sets focus to this tab bar
func grab_tab_bar_focus() -> void:
	
	var tab: TabBar = get_tab_bar()
	if ( tab.is_visible_in_tree() ):
		
		tab.grab_focus()

## translates tab names
func set_tabs_translation() -> void:
	
	for i: int in mini( get_tab_count(), tab_translation_keys.size() ):
		
		set_tab_title( i, tr( tab_translation_keys[ i ] ) )


func _on_visibility_changed() -> void:
	var is_visible_tree := is_visible_in_tree()
	
	set_process_input( is_visible_tree )
	
	if ( is_visible_tree ):
		
		if ( _auto_reset ):
			
			current_tab = initial_tab
		
		if ( auto_focus ):
			
			grab_tab_bar_focus.call_deferred()
	else:
		
		pass

func _on_window_gui_focus_changed( node: Control ) -> void:
	if ( not is_instance_valid( node ) ): return
	if ( node == self ): return
	
	child_has_focus = is_ancestor_of( node )
	focused_child = node if child_has_focus else null


func _on_settings_update( new_file: SettingsFile ) -> void:
	
	if ( new_file.translation != _current_translation ):
		
		_current_translation = new_file.translation
		set_tabs_translation()

static func _on_static_settings_update( new_file: SettingsFile ) -> void:
	
	_auto_reset = new_file.menu_auto_reset
