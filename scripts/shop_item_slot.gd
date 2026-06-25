#extends Control
#
## Drag your UI nodes into these variables in the inspector, or use $NodeName
#@onready var icon_rect = $TextureRect
#@onready var cost_label = $HBoxContainer/CostLabel
#@onready var buy_button = $BuyButton
#
#var current_item: ItemData
#
#func setup(item_data: ItemData):
	#current_item = item_data
	#
	## Assign the data to your UI nodes
	#icon_rect.texture = item_data.icon
	#cost_label.text = str(item_data.cost)
	#
	## Connect the buy button!
	#buy_button.pressed.connect(_on_buy_pressed)
#
#func _on_buy_pressed():
	#print("Player wants to buy: " + current_item.item_name + " with ID " + str(current_item.item_id))
	#var store_array_index: int = get_index()
#
	#if Globals.player_bal >= current_item.cost:
		#Globals.add_purchase_to_inventory.emit(current_item.item_id, current_item.cost, store_array_index)
	#else:
		#ToastX.fridgesim("You're too poor for that!")
	## You can emit a signal here later to tell your inventory to add the item!
	
extends Control

# Drag your UI nodes into these variables in the inspector, or use $NodeName
@onready var icon_rect = $TextureRect
@onready var cost_label = $HBoxContainer/CostLabel
@onready var buy_button = $BuyButton

var current_item: ItemData

func setup(item_data: ItemData):
	current_item = item_data
	
	# Assign the data to your UI nodes
	icon_rect.texture = item_data.icon
	cost_label.text = str(item_data.cost)
	
	# Format the tooltip for hovering 
	self.tooltip_text = item_data.item_name + "\n"
	self.tooltip_text += "Cost: " + str(item_data.cost) + "\n"
	self.tooltip_text += "Effect: " + item_data.attrb
	
	# Connect the buy button!
	buy_button.pressed.connect(_on_buy_pressed)

func _on_buy_pressed():
	print("Player wants to buy: " + current_item.item_name + " with ID " + str(current_item.item_id))
	var store_array_index: int = get_index()

	if Globals.player_bal >= current_item.cost:
		Globals.add_purchase_to_inventory.emit(current_item.item_id, current_item.cost, store_array_index)
	else:
		Globals.error_sfx.play()
		ToastX.fridgesim("You're too poor for that!")
