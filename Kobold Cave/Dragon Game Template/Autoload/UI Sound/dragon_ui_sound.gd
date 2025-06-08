
extends Object
class_name DragonUISound
## this class provides some nodes for ui to hook up to.
##
## You'll have to provide teh sounds yourself,
## do so in another script so this script gets loaded


const SFX_BUS := &"SFX"


## node used to play focus sfx
static var sfx_focus: AudioStreamPlayer

## node use to play button sfx
static var sfx_button: AudioStreamPlayer
## pitch of the sound when a button goes down
static var button_down_pitch: float = 0.8
## pitch of the sound whena button goes up
static var button_up_pitch: float = 1.2

## Node used to play range sfx
static var sfx_range: AudioStreamPlayer
## lowest pitch the range sfx can be
static var range_pitch_min: float = 0.8
## highest pitch the range sfx can be
static var range_pitch_max: float = 1.2

## Node used to play tabs
static var sfx_tabs: AudioStreamPlayer
## lowest pitch the range sfx can be
static var tabs_pitch_min: float = 0.5
## highest pitch the range sfx can be
static var tabs_pitch_max: float = 1.5


static func _static_init() -> void:
	
	var tree: SceneTree = Engine.get_main_loop()
	
	tree.node_added.connect( _on_tree_node_added, CONNECT_DEFERRED )
	
	# make sure this node exists
	if ( not DragonSound.gui ):
		await tree.physics_frame
	
	sfx_focus = AudioStreamPlayer.new()
	sfx_focus.bus = SFX_BUS
	sfx_focus.volume_linear = 0.2
	DragonSound.gui.add_child( sfx_focus )
	
	sfx_button = AudioStreamPlayer.new()
	sfx_button.bus = SFX_BUS
	DragonSound.gui.add_child( sfx_button )
	
	sfx_range = AudioStreamPlayer.new()
	sfx_range.bus = SFX_BUS
	DragonSound.gui.add_child( sfx_range )
	
	sfx_tabs = AudioStreamPlayer.new()
	sfx_tabs.bus = SFX_BUS
	DragonSound.gui.add_child( sfx_tabs )


static func connect_button( button: BaseButton ) -> void:
	
	if ( not button.button_down.is_connected( _on_button_down ) ):
		
		button.button_down.connect( _on_button_down )
	
	if ( not button.button_up.is_connected( _on_button_up ) ):
		
		button.button_up.connect( _on_button_up )

static func connect_range( range_node: Range ) -> void:
	
	if ( not range_node.value_changed.is_connected( _on_range_value_changed ) ):
		
		range_node.value_changed.connect( _on_range_value_changed.bind( range_node ) )

static func connect_tabbar( tabbar: TabBar ) -> void:
	
	if ( not tabbar.tab_selected.is_connected( _on_tabbar_tab_changed ) ):
		
		tabbar.tab_selected.connect( _on_tabbar_tab_changed.bind( tabbar ) )


static func _on_tree_node_added( node: Node ) -> void:
	
	if ( node is BaseButton ):
		
		connect_button( node )
	elif ( node is Range ):
		
		connect_range( node )
	elif( node is TabBar ):
		
		connect_tabbar( node )
	
	if ( node is Control ):
		
		if ( node is Container ): return
		#if ( node is Range ): return
		#if ( node is TabBar ): return
		
		( node as Control ).focus_entered.connect( _on_any_focus_entered )


static func _on_any_focus_entered() -> void:
	
	sfx_focus.play()

static func _on_button_down() -> void:
	
	sfx_button.pitch_scale = button_down_pitch
	sfx_button.play()

static func _on_button_up() -> void:
	
	sfx_button.pitch_scale = button_up_pitch
	sfx_button.play()

static func _on_range_value_changed( value: float, range_node: Range ) -> void:
	
	var pitch: float = remap( value, range_node.min_value, range_node.max_value, range_pitch_min, range_pitch_max )
	if ( not is_finite( pitch ) ):
		
		pitch = 1.0
	
	sfx_range.pitch_scale = pitch
	sfx_range.play()

static func _on_tabbar_tab_changed( tab: int, tabbar: TabBar ) -> void:
	
	var pitch: float = remap( tab + 1 , 0, tabbar.tab_count, tabs_pitch_min, tabs_pitch_max )
	
	if ( not is_finite( pitch ) ):
		
		pitch = 1.0
	
	sfx_tabs.pitch_scale = pitch
	sfx_tabs.play()
