@tool
extends Level


@export var blood_images: Array[ Node2D ] = []

func _ready() -> void:
	super()
	
	if ( Engine.is_editor_hint() ):
		return
	
	if ( not Settings.current_file.show_blood ):
		
		for item: Node2D in blood_images:
			
			item.hide()
