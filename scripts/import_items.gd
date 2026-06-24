@tool
extends EditorScript

const SAVE_PATH = "res://items/"
const CSV_PATH = "res://data/itemTable.csv"
const SPRITE_SHEET_PATH = "res://assets/fruit-art.png" 
const ICON_SIZE = 32
const SHEET_COLUMNS = 16 

func _run():
	var file = FileAccess.open(CSV_PATH, FileAccess.READ)
	if file == null:
		print("Could not find CSV file!")
		return
		
	var main_atlas = load(SPRITE_SHEET_PATH)
	if main_atlas == null:
		print("Could not find the Sprite Sheet!")
		return
		
	var headers = file.get_csv_line()
	
	# We will use this variable as both our counter AND our math ID!
	var item_id = 0 
	
	while not file.eof_reached():
		var line = file.get_csv_line()
		
		# We only need 3 columns now: Name, Cost, Description
		if line.size() < 3 or line[0] == "": 
			continue
			
		var new_item = ItemData.new()
		new_item.item_id = line[0]
		new_item.item_name = line[1]
		new_item.attrb = line[2]
		new_item.cost = line[3].to_int()
		# Calculates the exact grid coordinates based on the item_id
		var grid_x = item_id % SHEET_COLUMNS
		var grid_y = item_id / SHEET_COLUMNS
		
		var new_icon = AtlasTexture.new()
		new_icon.atlas = main_atlas
		new_icon.region = Rect2(grid_x * ICON_SIZE, grid_y * ICON_SIZE, ICON_SIZE, ICON_SIZE)
		
		new_item.icon = new_icon
		
		var file_name = line[0].to_lower().replace(" ", "_") + ".tres"
		var full_save_path = SAVE_PATH + file_name
		
		ResourceSaver.save(new_item, full_save_path)
		
		# Increase the ID by 1 so the next item gets the next slot on the sprite sheet
		item_id += 1 
		
	print("Success! Generated ", item_id, " items.")
