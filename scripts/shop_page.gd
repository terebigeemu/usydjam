extends Control

# Drag your shop_item_slot.tscn file into this variable in the Inspector!
@export var item_slot_scene: PackedScene 

# The folder where all your generated .tres files live
const ITEMS_FOLDER = "res://items/"

@onready var buy_grid = $BuySection/BuyGrid

var all_game_items: Array[ItemData] = []

func _ready():
	load_all_items_from_folder()
	roll_new_shop_items()

func load_all_items_from_folder():
	# Look inside the items folder
	var files = DirAccess.get_files_at(ITEMS_FOLDER)
	
	for file in files:
		# Godot adds ".remap" to resources when a game is exported, 
		# so we check for both to prevent bugs later!
		if file.ends_with(".tres") or file.ends_with(".tres.remap"):
			var clean_name = file.replace(".remap", "")
			var item = load(ITEMS_FOLDER + clean_name) as ItemData
			
			if item != null:
				all_game_items.append(item)
				
	print("Shop loaded ", all_game_items.size(), " items into memory.")

func roll_new_shop_items():
	# 1. Clear out any old items currently in the grid
	for child in buy_grid.get_children():
		child.queue_free()
		
	# 2. Safety check: Make sure we have items to pick from
	if all_game_items.size() < 3:
		print("Not enough items to populate shop!")
		return
		
	# 3. Create a temporary copy of our items array and shuffle it
	var temp_items = all_game_items.duplicate()
	temp_items.shuffle() # This uses Godot's built-in RNG to randomize the array!
	
	# 4. Grab the first 3 items from the newly shuffled array
	for i in range(3):
		var chosen_item = temp_items[i]
		
		# 5. Spawn the UI slot and add it to the grid
		var new_slot = item_slot_scene.instantiate()
		buy_grid.add_child(new_slot)
		
		# 6. Pass the item data (including the icon) into the slot
		new_slot.setup(chosen_item)
		print(str(chosen_item))
