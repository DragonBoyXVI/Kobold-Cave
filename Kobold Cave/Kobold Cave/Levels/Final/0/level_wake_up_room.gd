extends Level


@export var blood_images: Array[ Node2D ] = []

func _ready() -> void:
	
	if ( not Settings.data.show_blood ):
		
		for item: Node2D in blood_images:
			
			item.hide()
