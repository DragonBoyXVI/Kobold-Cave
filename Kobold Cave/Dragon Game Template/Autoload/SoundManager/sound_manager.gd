
extends Node
## Manager that pools audio related nodes
##
## ditto


var avaliable_players: Array[ AudioStreamPlayer ] = []
var avaliable_players_2d: Array[ AudioStreamPlayer2D ] = []
var avaliable_players_3d: Array[ AudioStreamPlayer3D ] = []


func make_new_player() -> void:
	
	var new_player := AudioStreamPlayer.new()
	new_player.finished.connect( _on_player_finished.bind( new_player ) )
	
	add_child( new_player )
	avaliable_players.append( new_player )

func make_new_player_2d() -> void:
	
	var new_player := AudioStreamPlayer2D.new()
	new_player.finished.connect( _on_player_finished_2d.bind( new_player ) )
	
	add_child( new_player )
	avaliable_players_2d.append( new_player )

func make_new_player_3d() -> void:
	
	var new_player := AudioStreamPlayer3D.new()
	new_player.finished.connect( _on_player_finished_3d.bind( new_player ) )
	
	add_child( new_player )
	avaliable_players_3d.append( new_player )


func play_sound( stream: AudioStream, bus_name: StringName = &"Master" ) -> AudioStreamPlayer:
	
	if ( avaliable_players.size() == 0 ):
		make_new_player()
	
	var player: AudioStreamPlayer = avaliable_players.pop_back()
	player.stream = stream
	player.bus = bus_name
	
	player.play.call_deferred()
	return player

func play_sound_2d( stream: AudioStream, location: Vector2, random_pitch_range: float = 0.0, bus_name: StringName = &"Master" ) -> AudioStreamPlayer2D:
	
	if ( avaliable_players_2d.size() == 0 ):
		make_new_player_2d()
	
	var player: AudioStreamPlayer2D = avaliable_players_2d.pop_back()
	player.position = location
	player.stream = stream
	player.bus = bus_name
	
	if ( random_pitch_range > 0.0 ):
		
		player.pitch_scale += randf_range( -random_pitch_range, random_pitch_range )
	
	player.play.call_deferred()
	return player

func play_sound_3d( stream: AudioStream, location: Vector3, random_pitch_range: float = 0.0, bus_name: StringName = &"Master" ) -> AudioStreamPlayer3D:
	
	if ( avaliable_players_3d.size() == 0 ):
		make_new_player_3d()
	
	var player: AudioStreamPlayer3D = avaliable_players_3d.pop_back()
	player.position = location
	player.stream = stream
	player.bus = bus_name
	
	if ( random_pitch_range > 0.0 ):
		
		player.pitch_scale += randf_range( -random_pitch_range, random_pitch_range )
	
	player.play.call_deferred()
	return player


func stop_all_sound() -> void:
	
	for child: Node in get_children():
		if ( child is AudioStreamPlayer ):
			
			child.stop()
			child.finished.emit()

func stop_all_sound_2d() -> void:
	
	for child: Node in get_children():
		if ( child is AudioStreamPlayer2D ):
			
			child.stop()
			child.finished.emit()

func stop_all_sound_3d() -> void:
	
	for child: Node in get_children():
		if ( child is AudioStreamPlayer3D ):
			
			child.stop()
			child.finished.emit()


func _on_player_finished( player: AudioStreamPlayer ) -> void:
	
	player.stream = null
	player.pitch_scale = 1.0
	player.volume_linear = 1.0
	player.bus = &"Master"
	avaliable_players.append( player )

func _on_player_finished_2d( player: AudioStreamPlayer2D ) -> void:
	
	player.stream = null
	player.pitch_scale = 1.0
	player.volume_linear = 1.0
	player.bus = &"Master"
	player.transform = Transform2D()
	avaliable_players_2d.append( player )

func _on_player_finished_3d( player: AudioStreamPlayer3D ) -> void:
	
	player.stream = null
	player.pitch_scale = 1.0
	player.volume_linear = 1.0
	player.bus = &"Master"
	player.transform = Transform3D()
	avaliable_players_3d.append( player )
