
extends Node
## place for a signals related to Kobold Cave


## emitted when the player runs out of health
signal player_died

## emitted when we want to pause the room for hitstun
signal player_hitstun( damage: BaseDamage )

## emitted when the player touches the goal trigger
signal goal_touched

## emitted when the "next" button is pressed on the
## level clear screen
signal level_clear_next_pressed
