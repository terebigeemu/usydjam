extends Control

@onready var icon_rect = %IconRect
@onready var title_label = %TitleLabel
@onready var info_label = %InfoLabel

var current_employee: EmployeeData

func setup(emp_data: EmployeeData):
	current_employee = emp_data
	
	if emp_data.icon:
		icon_rect.texture = emp_data.icon
		
	title_label.text = emp_data.title
	
	# Display a quick summary of their stats
	var info_text = "Lvl: " + emp_data.level + " | Affinity: " + str(emp_data.affinity)
	info_text += "\nLikes: " + emp_data.preferences
	
	info_label.text = info_text
	
	# Tooltip for extra hidden info
	self.tooltip_text = "Encounter Rate: " + str(emp_data.encounter)
