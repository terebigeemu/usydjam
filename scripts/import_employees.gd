@tool
extends EditorScript

const SAVE_PATH = "res://employees/"
const CSV_PATH = "res://Data/EmployeeTable.csv"

# Put all possible preference words here!
const PREF_WORDS = [
	"Sweet", "Sour", "Fruit", "Spicy", "Vegetable", "Dessert", "Pastry", "Drink", "Savory",
	"Salty", "Snack", "Condiment/Ingredient", "Carbs", "Earthy", "Bitter", "Creamy", "Salad",
	"Minty", "Mild Sweet", "Tangy", "Pungent", "Dairy", "Neutral"
]

func _run():
	var file = FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		print("Could not find CSV file!")
		return
		
	var headers = file.get_csv_line()
	var count = 0
	
	while not file.eof_reached():
		var line = file.get_csv_line()
		
		# Assuming minimum 8 columns from your list
		if line.size() < 8 or line[0] == "": 
			continue
			
		var emp = EmployeeData.new()
		emp.title = line[0]
		emp.level = line[1]
		emp.affinity = line[2].to_int()
		
		# Convert CSV strings (like "true", "TRUE", or "1") to booleans
		emp.promotion = (line[3].to_lower() == "true" or line[3] == "1")
		emp.death = (line[4].to_lower() == "true" or line[4] == "1")
		emp.encounter = line[5].to_float()
		emp.preferencecount = line[6].to_int()
		emp.seenstatus = (line[7].to_lower() == "true" or line[7] == "1")
		
		# --- RANDOM PREFERENCE LOGIC ---
		var available_prefs = PREF_WORDS.duplicate()
		available_prefs.shuffle() # Randomize the list
		
		var chosen_prefs = []
		# Loop based on the preference count, ensure we don't ask for more words than exist
		var max_picks = min(emp.preferencecount, available_prefs.size())
		for i in range(max_picks):
			chosen_prefs.append(available_prefs[i])
			
		# Join them together into a single string (e.g., "Coffee, Quiet, Money")
		emp.preferences = ", ".join(chosen_prefs)
		
		# PNG ICON LOGIC
		# Assumes your icons are named after the employee title (e.g., "manager.png")
		var clean_title = emp.title.to_lower().replace(" ", "_")
		var icon_path = "res://assets/" + clean_title + ".png"
		
		if ResourceLoader.exists(icon_path):
			emp.icon = load(icon_path)
		else:
			# Fallback if no specific PNG is found
			print("Warning: No PNG found for ", emp.title, ". Using default.")
			if ResourceLoader.exists("res://assets/EmployeeTest.png"):
				emp.icon = load("res://assets/EmployeeTest.png")
		
		# Save the resource with a unique ID (count) to prevent overwriting duplicates
		var full_save_path = SAVE_PATH + clean_title + "_" + str(count) + ".tres"
		ResourceSaver.save(emp, full_save_path)
		count += 1
		
	print("Success! Generated ", count, " employees.")
