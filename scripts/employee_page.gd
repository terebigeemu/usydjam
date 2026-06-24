extends Control

@export var employee_slot_scene: PackedScene 

const EMP_FOLDER = "res://employees/"

@onready var emp_grid = $EmployeeSection/EGrid

var all_employees: Array[EmployeeData] = []

func _ready():
	load_employees()
	populate_employee_board()

func load_employees():
	var files = DirAccess.get_files_at(EMP_FOLDER)
	
	for file in files:
		if file.ends_with(".tres") or file.ends_with(".tres.remap"):
			var clean_name = file.replace(".remap", "")
			var emp = load(EMP_FOLDER + clean_name) as EmployeeData
			
			if emp != null:
				all_employees.append(emp)

func populate_employee_board():
	for child in emp_grid.get_children():
		child.queue_free()
		
	# Spawn a slot ONLY for employees that have been encountered
	for emp in all_employees:
		# Check if the employee has been seen/encountered before spawning their slot
		# (If you named the variable 'encountered' in your EmployeeData script, 
		# just change 'seenstatus' to 'encountered' here!)
		if emp.seenstatus == true:
			var new_slot = employee_slot_scene.instantiate()
			emp_grid.add_child(new_slot)
			new_slot.setup(emp)
