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
