extends Node
## Global music manager, handles music arranged as a scene


## the current music
var current_music: Music :
	set( new_music ):
		
		current_music = new_music
		music_changed.emit( new_music )


## emitted when teh song changes
signal music_changed( new_music: Music )


func _ready() -> void:
	
	Settings.updated.connect( _on_settings_updated, CONNECT_DEFERRED )


## changes the music and kills the old music
func set_music_by_packed( music_scene: PackedScene ) -> void:
	
	if ( not music_scene.can_instantiate() ):
		
		push_error( "This music cant be instanced!" )
		return
	
	# kill current music
	if ( current_music ):
		
		current_music.stop()
		await current_music.stopped
	
	# make new music
	var new_music := ( music_scene.instantiate() as Music )
	add_child( new_music )
	
	current_music = new_music


## play the current music
func play_music() -> void:
	
	if ( current_music ):
		
		current_music.play()

## pause the current music
func pause_music() -> void:
	
	if ( current_music ):
		
		current_music.pause()

## unpause the current music
func unpause_music() -> void:
	
	if ( current_music ):
		
		current_music.unpause()

## stop the current music
func stop_music() -> void:
	
	if ( current_music ):
		
		current_music.stop()


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	if ( recived_data.pause_music_when_paused ):
		
		process_mode = Node.PROCESS_MODE_PAUSABLE
	else:
		
		process_mode = Node.PROCESS_MODE_ALWAYS
