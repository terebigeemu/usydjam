extends Control

@onready var icon_rect = %IconRect
@onready var title_label = %TitleLabel

# You now need references to all the split-up labels
@onready var level_label = %LevelLabel 
@onready var affinity_label = %AffinityLabel
@onready var likes_label = %LikesLabel

var current_employee: EmployeeData

func setup(emp_data: EmployeeData):
	current_employee = emp_data
	
	if emp_data.icon:
		icon_rect.texture = emp_data.icon
		
	title_label.text = emp_data.title
	
	# Update each label individually
	level_label.text = "Lvl: " + str(emp_data.level)
	affinity_label.text = str(emp_data.affinity)
	likes_label.text = "Likes: " + emp_data.preferences
	var formatted_likes = emp_data.preferences.replace(", ", "\n- ").replace(",", "\n- ")

	likes_label.text = "\nLikes:\n- " + formatted_likes
	self.tooltip_text = "Encounter Rate: " + str(emp_data.encounter)

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
