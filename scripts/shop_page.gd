extends Control

# Drag your shop_item_slot.tscn file into this variable in the Inspector!
@export var item_slot_scene: PackedScene 
@export var sell_slot_scene: PackedScene 

# The folder where all your generated .tres files live
const ITEMS_FOLDER = "res://items/"

@onready var buy_grid = $BuySection/BuyGrid
@onready var sell_grid = $SellSection/SellGrid
@onready var coins_label = $CoinsLabel

@onready var cell_array = Globals.cell_array
@onready var cell_item_array = Globals.cell_item_array

@onready var stash_array = Globals.stash_array
@onready var stash_item_array = Globals.stash_item_array

var all_game_items: Array[ItemData] = []

func _ready():	
	Globals.remove_item_from_shop.connect(_on_remove_item_from_shop)
	Globals.refresh_sell_shop.connect(_on_refresh_sell_shop)
	Globals.refresh_buy_shop.connect(_on_refresh_buy_shop)

	await get_tree().create_timer(1).timeout

	load_all_items_from_folder()
	roll_new_shop_items()
	load_sellable_items()

func load_all_items_from_folder(): # WARNING: THIS IS NOT INDEX-ORDERED
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
	temp_items.shuffle() 
	
	# 4. Grab the first 3 items from the newly shuffled array
	for i in range(3):
		var chosen_item = temp_items[i]
		
		# 5. Spawn the UI slot and add it to the grid
		var new_slot = item_slot_scene.instantiate()
		buy_grid.add_child(new_slot)
		
		# 6. Pass the item data (including the icon) into the slot
		new_slot.setup(chosen_item)
		print(str(chosen_item))
		
func load_sellable_items():
	# Clear out any old items currently in the grid
	for child in sell_grid.get_children():
		child.queue_free()
		
	# Safety check: Make sure we have items to pick from
	if all_game_items.size() == 0:
		print("You will own nothing and be happy")
		return
		
	# Inventory array
	var temp_inventory_array = cell_array + stash_array
	var temp_inventory_item_array = cell_item_array + stash_item_array
	
	print("temp_inventory_item_array = " + str(temp_inventory_item_array))
	
	var temp_items = all_game_items.duplicate()

	var n_i: int = 0
	
	for i in temp_inventory_item_array:
				
		if i != Globals.item_empty:
			var matching_item_in_temp_items: int
			var chosen_item
			
			# is this cursed - yes
			# am i cursed - yes
			# does it work - yes
			# should you stop asking questions - yes
			
			var n_j: int = 0
			
			for j in temp_items:
				if j.item_id == i:
					matching_item_in_temp_items = j.item_id
					print("j has been found! = " + str(matching_item_in_temp_items))
					chosen_item = temp_items[n_j]
					break
				n_j += 1
				
			# Spawn the UI slot and add it to the grid
			var new_slot = sell_slot_scene.instantiate()
			sell_grid.add_child(new_slot)
			
			# Pass the item data (including the icon) into the slot
			new_slot.setup(chosen_item, n_i)
			print(str(chosen_item) + str(n_i))
			
		n_i += 1
			

func _on_refresh_sell_shop() -> void:
	load_sellable_items()
	
func _on_refresh_buy_shop() -> void:
	roll_new_shop_items()

func _on_remove_item_from_shop(store_array_index: int) -> void:	
	print("called _on_remove_item_from_shop with store_array_index " + str(store_array_index))
	Globals.refresh_sell_shop.emit()
	buy_grid.get_child(store_array_index).queue_free()

func _process(delta: float) -> void:
	# the smart thing to do would be to use a signal to update this
	# the lazy thing to do is just chuck it here
	# i do the lazy thing
	# huh what's optimisation?
	coins_label.text = "You have " + str(Globals.player_bal) + " coins!"
