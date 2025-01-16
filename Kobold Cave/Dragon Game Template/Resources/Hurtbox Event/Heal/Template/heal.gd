extends BaseHeal
class_name Heal
## A simple heal
## 
## A simple heal, less complicated than damage


func _init( amt := 0.0 ) -> void:
	
	amount = amt

func _to_string() -> String:
	
	const text := "Heal\nAmount: %s"
	return text % amount


func _heal( health_node: NodeHealth ) -> bool:
	
	if ( amount <= 0.0 ): return false
	
	health_node.health.current += amount
	return true
