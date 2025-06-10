@tool
extends CharacterBody2D
class_name Entity
## Base scene for all entities, like the player
##
## ditto


signal enabled
signal disabled


@export var damage_profile: DamageProfile
@export var hitbox: ObjHitbox2D
@export var model: KoboldModel2D
@export var state_machine: StateMachine


var is_facing_right: bool = true :
	set( new ):
		
		is_facing_right = new
		model.set_facing_right( new )


func _init() -> void:
	
	collision_layer = 0b10
	
	if ( Engine.is_editor_hint() ):
		
		child_entered_tree.connect( _util_child_entered_tree )
		return

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return
	
	Settings.connect_changed_callback( _on_settings_updated )
	
	if ( damage_profile ):
		
		damage_profile.took_damage.connect( _on_hurt )
		damage_profile.took_heal.connect( _on_heal )
		damage_profile.died.connect( _on_died )
	
	if ( hitbox ):
		
		hitbox.recived_event.connect( _on_hitbox_recived_event )
	
	#if ( health_node ):
		#
		#health_node.pre_hurt.connect( _on_node_health_pre_hurt )
		#health_node.hurt.connect( _on_node_health_hurt )
		#health_node.pre_healed.connect( _on_node_health_pre_healed )
		#health_node.healed.connect( _on_node_health_healed )
		#health_node.died.connect( _on_node_health_died )

func _notification( what: int ) -> void:
	
	match what:
		
		NOTIFICATION_PAUSED:
			
			if ( Engine.is_editor_hint() ): return
			
			print( "paused" )
			show.call_deferred()
			model.set_deferred( &"modulate:a", maxf( 0.8, model.modulate.a ) )

func _property_can_revert( property: StringName ) -> bool:
	const revertable: PackedStringArray = [
		"collision_layer",
	]
	
	return revertable.has( property )

func _property_get_revert( property: StringName ) -> Variant:
	
	match property:
		&"collision_layer": return 0b10
	
	return null


## virtual
func _facing_changed( _facing_right: bool ) -> void:
	pass


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


func _on_hurt( damage: Damage ) -> void:
	
	model.flash_color( damage.to_color(), damage.amount / 5.0 )

func _on_heal( heal: Heal ) -> void:
	
	model.flash_color( heal.to_color(), heal.amount )

func _on_died() -> void:
	
	queue_free()


func _on_hitbox_recived_event( event: HurtboxEvent ) -> void:
	
	if ( event is Damage ):
		
		damage_profile.take_damage( event )
	elif ( event is Heal ):
		
		damage_profile.take_heal( event )


func _on_settings_updated( recived_data: SettingsFile ) -> void:
	
	_settings_update( recived_data )

## virtual
func _settings_update( _recived_data: SettingsFile ) -> void:
	pass


func _util_child_entered_tree( node: Node ) -> void:
	
	if ( node is KoboldModel2D and not model ):
		
		model = node
	elif ( node is ObjHitbox2D and not hitbox ):
		
		hitbox = node
	elif ( node is StateMachine and not state_machine ):
		
		state_machine = node
