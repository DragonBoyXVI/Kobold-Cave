@tool
extends CharacterBody2D
class_name Entity
## Base scene for all entities, like the player
##
## ditto


signal enabled
signal disabled


@export var health_node: NodeHealth
@export var model: DragonModel2D


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return
	
	Settings.updated.connect( _on_settings_updated )
	if ( Settings.data ):
		
		_on_settings_updated( Settings.data )
	
	if ( health_node ):
		
		health_node.pre_hurt.connect( _on_node_health_pre_hurt )
		health_node.hurt.connect( _on_node_health_hurt )
		health_node.pre_healed.connect( _on_node_health_pre_healed )
		health_node.healed.connect( _on_node_health_healed )
		health_node.died.connect( _on_node_health_died )


func out_of_bounds() -> void:
	
	queue_free()


func enable() -> void:
	
	_enable()
	enabled.emit()

func disable() -> void:
	
	_disable()
	disabled.emit()

## virtual
func _enable() -> void:
	
	process_mode = PROCESS_MODE_INHERIT

## virtual
func _disable() -> void:
	
	process_mode = PROCESS_MODE_DISABLED


func _on_node_health_pre_hurt( damage: Damage ) -> void:
	
	model.flash_color( damage.to_color(), damage.amount / 5.0 )
	_pre_hurt( damage )

func _on_node_health_hurt( damage: Damage ) -> void:
	
	_hurt( damage )

func _on_node_health_pre_healed( heal: Heal ) -> void:
	
	model.flash_color( heal.to_color(), heal.amount / 1.25 )
	_pre_healed( heal )

func _on_node_health_healed( heal: Heal ) -> void:
	
	_healed( heal )

func _on_node_health_died() -> void:
	
	_death()


## virtual
func _pre_hurt( _damage: Damage ) -> void:
	pass

## virtual
func _hurt( _damage: Damage ) -> void:
	pass

## virtual
func _pre_healed( _heal: Heal ) -> void:
	pass

## virtual
func _healed( _heal: Heal ) -> void:
	pass

## virtual
func _death() -> void:
	
	queue_free()


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_settings_update( recived_data )

## virtual
func _settings_update( _recived_data: SettingsFile ) -> void:
	pass


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is DragonModel2D and not model ):
		
		model = node
	elif ( node is NodeHealth and not health_node ):
		
		health_node = node
