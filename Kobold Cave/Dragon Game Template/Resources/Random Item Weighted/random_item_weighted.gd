@icon( "res://Dragon Game Template/Icons/random_item_weighted.png" )
extends RefCounted
class_name RandomItemWeighted
## Lets you randomly pick an item with a weight
##
## This resource lets you quickly pick a random item, and assign
## items weights so that one item is more likely to appear than
## another.[br]
## doesn't use [RandomNumberGenerator] bc idfk how but you can do it yourself ig lol


## Inner class for items
class WeightedItem:
	extends RefCounted
	
	
	func _to_string() -> String:
		
		const text := "Item: {0} Weight: {1}"
		return text.format( [ item, weight ] )
	
	func _init( i: Variant = null, w: int = 1 ) -> void:
		
		item = i
		weight = absi( w )
	
	
	## the item itself
	var item: Variant
	## the weight of the item
	var weight: int


## if true, any item this picks is removed from the items array
var remove_picked_item := false
## all held items
var items: Array[ WeightedItem ] = []


func _to_string() -> String:
	
	const text := "RandomItemWeighted: current items:\n %s"
	return text #% str( _items )


## Adds an item to the list
func add_item( item: Variant, weight: int ) -> void:
	
	var new_item := WeightedItem.new( item, weight )
	items.append( new_item )

## Gets an item from the list randomly
func get_item() -> Variant:
	
	# gets the total item weight
	var total_weight: int = 0
	for item: WeightedItem in items:
		
		total_weight += item.weight
	
	# return item here
	for index: int in items.size():
		
		var item := items[ index ]
		
		if ( total_weight < item.weight ):
			
			if ( remove_picked_item ):
				
				items.remove_at( index )
				return item
			else:
				
				total_weight -= item.weight
	
	# fail safe
	return null

## Clears all contained items and weights
func clear() -> void:
	
	items.clear()
