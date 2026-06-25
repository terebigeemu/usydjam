extends Node

@onready var cell_array = Globals.cell_array
@onready var cell_item_array = Globals.cell_item_array

const ITEMS_FOLDER = "res://items/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_all_employees() # I love duplicating functions
	Globals.employee_takes_from_fridge.connect(_employee_picks_food_from_fridge_or_smth_idk)
	pass

# grab attributes from foods and spit them out as separate values

func food_attribute_parser(id: int) -> Array:
	
	# get all the foods
	
	var filepath: String = ITEMS_FOLDER + str(id) + ".tres"
	print("accessing " + filepath)
	var clean_name = filepath.replace(".remap", "")
	var item = load(clean_name) as ItemData
	
	print(str(item))
	
	# remove whitespace
	var unparsed_attrb: String = item.attrb
	unparsed_attrb = unparsed_attrb.replace(" ","")
	
	# split amongst commas
	var unparsed_attrb_array: Array # why not
	unparsed_attrb_array = unparsed_attrb.split(",")
	
	# this is where our clean array should theoretically go
	var attrb_array = ["AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS", "AMOGUS"] # prefill with empty items
	
	var j: int = 0
	
	for i in unparsed_attrb_array:
		attrb_array[j] = i
		j += 1
	
	print(attrb_array)
	return attrb_array
	
func food_cost(id: int) -> int:
	# get all the foods
	
	var filepath: String = ITEMS_FOLDER + str(id) + ".tres"
	print("accessing " + filepath)
	var clean_name = filepath.replace(".remap", "")
	var item = load(clean_name) as ItemData
	
	print(str(item))
	
	return item.cost

func food_name(id: int) -> String:
	# get all the foods
	
	var filepath: String = ITEMS_FOLDER + str(id) + ".tres"
	print("accessing " + filepath)
	var clean_name = filepath.replace(".remap", "")
	var item = load(clean_name) as ItemData
	
	print(str(item))
	
	return item.item_name
	
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

func _employee_picks_food_from_fridge_or_smth_idk(employee_title: String) -> void:
		
	# Lookup employee title and match with ID
	# assumed to be immutable once runtime started. if its mutable then... oop
	
	var employee_preference_string: String
	var employee_preference_count: int
	
	for i in all_game_employees:
		if i.title == employee_title: # so efficient wahey
			print("Employee is " + i.title)
			employee_preference_string = i.preferences
			employee_preference_count = i.preferencecount
			
	# remove whitespace
	employee_preference_string = employee_preference_string.replace(" ","")
	
	var employee_preference_array: Array
	
	# split amongst commas
	employee_preference_array = employee_preference_string.split(",")
	
	# now get what's in the fridge and lookup the attributes
	
	var valid_cells = [] 	# we only want to pick from items that are there
	
	for i in cell_item_array:
		if i != Globals.item_empty:
			valid_cells.append(i)
			
	print(cell_item_array)
			
	# details of the best food in the fridge
	
	var pb_preference_points: int = 0
	var best_food_id: int = Globals.item_empty		
	var best_food_name: String
	var best_food_cost: float
	var likes_anything: bool = false	# did at least 1 food meet one of their prefs?
	
	# let affinity be preference points * arbitrary constant k
	
	if valid_cells.is_empty():
		pb_preference_points = -1
		
	elif not valid_cells.is_empty():

		for i in valid_cells:											# for each food
			print("currently analysing " + str(i))						# what's in the fridge?!
			var food_attrb_array: Array = food_attribute_parser(i)		# return prefs for each item
			var food_name: String = food_name(i)
			var food_cost: int = food_cost(i)
			var preference_points: int = 1							# how many points does this food win

			for j in food_attrb_array:		
				print("food_attrb_array j = " + j)						# for each j in food_attribute_array
				if j in employee_preference_array:						# if it matches any attribute in employee_pref_array, +1 point
					preference_points += 1		
					
			preference_points = preference_points + food_cost
	
			print("preference points for " + str(i) + " is equal to " + str(preference_points))
			
			if preference_points > pb_preference_points:
				best_food_id = i
				best_food_name = food_name
				pb_preference_points = preference_points - 1
				likes_anything = true
				print("new pb: preference points for " + str(i) + " is equal to " + str(preference_points))
								
		var best_food_index = cell_item_array.find(best_food_id)
		cell_item_array[best_food_index] = Globals.item_empty
		cell_array[best_food_index].frame = cell_item_array[best_food_index]
		
		Globals.update_slot_tooltip_signal.emit(cell_array[best_food_index], Globals.item_empty)
		
		print("food was taken: name = " + str(best_food_name))
		
	#var return_data: Array = []
		
	#return_data.append(best_food_id)
	#return_data.append(pb_preference_points)
	
	# and this is where i remembered this was a receiver method to a signal
	
	Globals.affinity_to_add = pb_preference_points
	Globals.affinity_to_add_hasbeenadded = false
												

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
