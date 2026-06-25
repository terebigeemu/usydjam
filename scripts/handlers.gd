extends Node

const ITEMS_FOLDER = "res://items/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_all_employees() # I love duplicating functions
	pass

# grab attributes from foods and spit them out as separate values

func food_attribute_parser(id: int) -> Array:
	var filepath: String = ITEMS_FOLDER + str(id) + ".tres"
	print("accessing " + filepath)
	var clean_name = filepath.replace(".remap", "")
	var item = load(ITEMS_FOLDER + clean_name) as ItemData
	
	# remove whitespace
	var unparsed_attrb: String = item.attrb
	unparsed_attrb = unparsed_attrb.replace(" ","")
	
	# split amongst commas
	var unparsed_attrb_array: Array # why not
	unparsed_attrb_array = unparsed_attrb.split(",")
	
	# this is where our clean array should theoretically go
	var attrb_array = [157, 157, 157, 157] # prefill with empty items
	
	var j: int = 0
	
	for i in unparsed_attrb_array:
		attrb_array[j] = i
		j += 1
	
	print(attrb_array)
	return attrb_array
	
# ctrl-c ctrl-v is my favourite keyboard shortcut

const EMP_FOLDER = "res://employees/"
var all_game_employees: Array[EmployeeData] = []

func load_all_employees():
	var files = DirAccess.get_files_at(EMP_FOLDER)
	for file in files:
		if file.ends_with(".tres") or file.ends_with(".tres.remap"):
			var clean_name = file.replace(".remap", "")
			var emp = load(EMP_FOLDER + clean_name) as EmployeeData
			if emp != null:
				all_game_employees.append(emp)
	

func employee_picks_food_from_fridge_or_smth_idk(employee_title: String) -> int:
		
	# Lookup employee title and match with ID
	# assumed to be immutable once runtime started. if its mutable then... oop
	
	
	for i in all_game_employees:
		if i.title == employee_title:
			print("Employee is " + i.title)
	
	#return cell_index
	return 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
