extends Control

# Drag your UI nodes into these variables in the inspector, or use $NodeName
@onready var icon_rect = $TextureRect
@onready var name_label = $NameLabel
@onready var cost_label = $CostLabel
@onready var buy_button = $BuyButton

var current_item: ItemData

func setup(item_data: ItemData):
	current_item = item_data
	
	# Assign the data to your UI nodes
	icon_rect.texture = item_data.icon
	name_label.text = item_data.item_name
	cost_label.text = str(item_data.cost) + " Coins"
	
	# Connect the buy button!
	buy_button.pressed.connect(_on_buy_pressed)

func _on_buy_pressed():
	print("Player wants to buy: ", current_item.item_name)
	# You can emit a signal here later to tell your inventory to add the item!
