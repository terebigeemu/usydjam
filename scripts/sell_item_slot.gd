extends Control

# Drag your UI nodes into these variables in the inspector, or use $NodeName
@onready var icon_rect = $TextureRect
@onready var cost_label = $HBoxContainer/CostLabel
@onready var sell_item = $SellButton

var current_item: ItemData

func setup(item_data: ItemData, combined_inventory_index: int):
	current_item = item_data
	
	# Assign the data to your UI nodes
	icon_rect.texture = item_data.icon
	cost_label.text = str(item_data.cost)
	
	# Format the tooltip for hovering 
	self.tooltip_text = item_data.item_name + "\n"
	self.tooltip_text += "Cost: " + str(item_data.cost) + "\n"
	self.tooltip_text += "Effect: " + item_data.attrb
	
	# Connect the buy button!
	sell_item.pressed.connect(_on_sell_pressed.bind(combined_inventory_index))
	
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
func _on_sell_pressed(combined_inventory_index: int):
	print("Player wants to sell: " + current_item.item_name + " with ID " + str(current_item.item_id))
	
	Globals.action_sale_in_inventory.emit(current_item.item_id, current_item.cost, combined_inventory_index)
