#@tool
extends Area2D
class_name AreaTrigger2D
## An area that triggers something when the player enters it
## 
## ditto


signal player_entered
signal player_left


enum DISABLE_AT {
	ENTER,
	LEAVE,
	NEVER
}


## if true, run the enter callback
@export var run_enter: bool
## if true, run the left callback
@export var run_leave: bool

@export var auto_disable: DISABLE_AT = DISABLE_AT.NEVER


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )


## virtual[br]
## called when the player enters this trigger
func _player_entered( _player: Player ) -> void:
	
	push_error( name, ": Func not implimented \"_player_entered\"" )

## virtual[br]
## called when the player leaves this trigger
func _player_left( _player: Player ) -> void:
	
	push_error( name, ": Func not implimented \"_player_left\"" )


func enable() -> void:
	
	_enable()
	show()

func disable() -> void:
	
	_disable()
	hide()

## virtual[br]
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual[br]
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED


func _on_body_entered( body: Node2D ) -> void:
	if ( not run_enter ): return
	if ( body is not Player ): return
	
	_player_entered( body as Player )
	player_entered.emit()
	if ( auto_disable == DISABLE_AT.ENTER ):
		
		disable.call_deferred()

func _on_body_exited( body: Node2D ) -> void:
	if ( not run_leave ): return
	if ( body is not Player ): return
	
	_player_left( body as Player )
	player_left.emit()
	if ( auto_disable == DISABLE_AT.LEAVE ):
		
		disable.call_deferred()
