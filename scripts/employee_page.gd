extends Control

@export var employee_slot_scene: PackedScene 

@onready var emp_grid = $EmployeeSection/EGrid

func _ready():
	# 1. Populate the board when the page first loads
	populate_employee_board()
	
	# 2. Listen for the signal! When the manager shouts that a new employee 
	# was encountered, we automatically run the populate function again.
	EmployeeManager.new_employee_encountered.connect(populate_employee_board)
	# 3. Listens for signal for affinity to be updated
	EmployeeManager.employee_affinity_updated.connect(populate_employee_board)

func populate_employee_board():
	for child in emp_grid.get_children():
		child.queue_free()
		
	# Look directly at the EmployeeManager's master list of employees!
	for emp in EmployeeManager.all_game_employees:
		# Check if the employee has been seen/encountered before spawning their slot
		if emp.seenstatus == true:
			var new_slot = employee_slot_scene.instantiate()
			emp_grid.add_child(new_slot)
			new_slot.setup(emp)
