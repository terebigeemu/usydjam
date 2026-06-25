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

func _make_custom_tooltip(for_text: String) -> Object:
	var label = Label.new()
	label.text = for_text

	# 1. Force the font size to be bigger (Change 24 to whatever you like!)
	label.add_theme_font_size_override("font_size", 48)

	# 2. Force the text to be 100% solid white (R, G, B, Alpha)
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))

	# 3. Create a solid background box
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 1.0) # Solid dark gray (Alpha is the last 1.0)
	style.set_content_margin_all(12)           # Add some padding around the text

	# Optional: Add a crisp white border for a pixel art look
	style.border_width_bottom = 2
	style.border_width_top = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(1.0, 1.0, 1.0, 1.0)

	label.add_theme_stylebox_override("normal", style)

	# Give the generated label back to Godot to display
	return label

func _on_buy_pressed():
	print("Player wants to buy: " + current_item.item_name + " with ID " + str(current_item.item_id))
	var store_array_index: int = get_index()

	if Globals.player_bal >= current_item.cost:
		Globals.add_purchase_to_inventory.emit(current_item.item_id, current_item.cost, store_array_index)
	else:
		Globals.error_sfx.play()
		ToastX.fridgesim("You're too poor for that!")
