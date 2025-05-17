
extends Node
## place for a signals related to Kobold Cave
##
## place for signals related to Kobold Cave


## emitted when the player needs to be reset
signal player_reset_needed( player: Player )
## emitted when the player runs out of health
signal player_died
## emitted when we want to pause the room for hitstun
signal player_hitstun( damage: Damage )

## emitted when the player should call the cameras
## focus again
signal give_camera_to_player

## used to connect a [Health] to the [UIHealth] node.
signal ui_connect_health( health: Health )
## used to connect a [BombThrower] to the [UIBombs] node.
signal ui_connect_bombs( bomb_thrower: BombThrower )

## emitted when the player touches the goal trigger
signal goal_touched

## emit to pause the current room
signal room_pause
## emit to unpause the current room
signal room_unpause

## used when a new spawn point should be set
signal level_set_spawn( spawn_marker: Marker2D )
## emitted when the "next" button is pressed on the
## level clear screen
signal level_clear_next_pressed

## emitted when a footstep is to be player
signal play_footstep( step_position: Vector2 )


#region Save game manager

## emitted when a game file is loaded
signal game_save_file_loaded( file: SaveFile )
## emitted when a game file is saved
signal game_save_file_saved

## emitted when a new secret is found
signal game_save_secret_found( flag: SaveFile.SECRETS )

#endregion
