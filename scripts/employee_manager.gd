extends Node

signal new_employee_encountered
signal employee_affinity_updated

const EMP_FOLDER = "res://employees/"
var all_game_employees: Array[EmployeeData] = []

func _ready():
	# This runs exactly once when the game boots up
	load_all_employees()

func load_all_employees():
	var files = DirAccess.get_files_at(EMP_FOLDER)
	for file in files:
		if file.ends_with(".tres") or file.ends_with(".tres.remap"):
			var clean_name = file.replace(".remap", "")
			var emp = load(EMP_FOLDER + clean_name) as EmployeeData
			if emp != null:
				all_game_employees.append(emp)


func summon_employee(current_player_level: String) -> EmployeeData:
	var valid_pool: Array[EmployeeData] = []
	var total_encounter_weight: float = 0.0
	
	for emp in all_game_employees:
		if emp.level == current_player_level:
			valid_pool.append(emp)
			total_encounter_weight += emp.encounter
			
	if valid_pool.is_empty():
		print("Error: No employees found for level ", current_player_level)
		return null
		
	var roll = randf() * total_encounter_weight
	var chosen_employee: EmployeeData = null
	
	for emp in valid_pool:
		roll -= emp.encounter
		if roll <= 0.0:
			chosen_employee = emp
			break
			
	if chosen_employee == null:
		chosen_employee = valid_pool.back()
		
	# Mark them as seen in the database right when they are rolled!
	if chosen_employee.seenstatus == false:
		chosen_employee.seenstatus = true
		new_employee_encountered.emit()
		
	return chosen_employee

# New Function for Adrian to use to update affinity
func add_affinity(emp: EmployeeData, amount_to_add: int):
	emp.affinity += amount_to_add
	print("Added ", amount_to_add, " affinity to ", emp.title, ". New total: ", emp.affinity)
	employee_affinity_updated.emit()
