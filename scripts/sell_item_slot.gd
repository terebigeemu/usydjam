extends Control

# Drag your UI nodes into these variables in the inspector, or use $NodeName
@onready var icon_rect = $TextureRect
@onready var name_label = $NameLabel
@onready var cost_label = $CostLabel
@onready var sell_item = $SellButton

var current_item: ItemData

func setup(item_data: ItemData, combined_inventory_index: int):
	current_item = item_data
	
	# Assign the data to your UI nodes
	icon_rect.texture = item_data.icon
	name_label.text = item_data.item_name
	cost_label.text = str(item_data.cost) + " Coins"
	
	# Connect the buy button!
	sell_item.pressed.connect(_on_sell_pressed.bind(combined_inventory_index))

func _on_sell_pressed(combined_inventory_index: int):
	print("Player wants to sell: " + current_item.item_name + " with ID " + str(current_item.item_id))
	
	Globals.action_sale_in_inventory.emit(current_item.item_id, current_item.cost, combined_inventory_index)
