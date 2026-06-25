# author: adrian
# don't ask what i'm doing as i have gone insane

extends Node

@export var shop_item_slot: PackedScene

# these variables should've been global but i realised too late.... xD xD xD
# no aaron, no one cares that your comp1001 lecturer said not to use globals
# i shall do what i want and i shall live freely in doing so

@onready var door_status: Label = $DoorStatus
@onready var cell1: AnimatedSprite2D = Globals.cell1
@onready var cell2: AnimatedSprite2D = Globals.cell2
@onready var cell3: AnimatedSprite2D = Globals.cell3
@onready var cell4: AnimatedSprite2D = Globals.cell4
@onready var cell5: AnimatedSprite2D = Globals.cell5
@onready var cell6: AnimatedSprite2D = Globals.cell6
@onready var stash100: AnimatedSprite2D = Globals.stash100
@onready var stash101: AnimatedSprite2D = Globals.stash101
@onready var stash102: AnimatedSprite2D = Globals.stash102
@onready var start_btn = $UI/PanelContainer/MarginContainer/MainMenu/StartBtn


var fridge_original_position: Vector2
var cell_original_positions: Array[Vector2]

var rng = RandomNumberGenerator.new()
var level = 0

const swap_inventory_index_empty: int = 69420 # this should break the code if used... yippee!

# registers

var enable_stash_edits = false
var swap_in_progress = false
var swap_cell_type = 2 # 0 = normal cell, 1 = stash cell, 2 = neither
var swap_cell_id
var swap_inventory_index: int = swap_inventory_index_empty

# item values (should be equal to frame ids)
# should initially be empty

const item_empty: int = Globals.item_empty

var item1: int = Globals.item1
var item2: int = Globals.item2
var item3: int = Globals.item3
var item4: int = Globals.item4
var item5: int = Globals.item5
var item6: int = Globals.item6

var item100: int = Globals.item100
var item101: int = Globals.item101
var item102: int = Globals.item102

# _array		= contains the NodePath
# _item_array	= contains the item ID (usually congruent with the spritesheet frame ID)
# cell_array and cell_item_array should generally never diverge except for
# momentary instances where the frames of a sprite might need to change

# yep these numbers totally aren't going to be confusing AT ALL

@onready var cell_array = Globals.cell_array
@onready var cell_item_array = Globals.cell_item_array

@onready var stash_array = Globals.stash_array
@onready var stash_item_array = Globals.stash_item_array


func _ready() -> void:
	fridge_original_position = fridge_sprite.position
	cell_original_positions = [cell1.position, cell2.position, cell3.position, cell4.position, cell5.position, cell6.position]
	
	# call cutscene? can be done in a diff script
	
	Globals.add_purchase_to_inventory.connect(_on_inventory_update)
	Globals.action_sale_in_inventory.connect(_on_action_sale_in_inventory)
	
	door_status.text = "init"
		
	# INIT
	
	var n_stash: int = 0
	var n_cell: int = 0

	for i in stash_array:
		i.frame = stash_item_array[n_stash]
		i.visible = false
		print("yes")
		n_stash += 1
	
	for i in cell_array:
		i.visible = false
			
	for i in cell_array:
		await get_tree().create_timer(0.05).timeout
		cell_item_array[n_cell] = rng.randi_range(0, 156)
		i.frame = cell_item_array[n_cell]
		i.visible = true
		n_cell += 1
		
	print("Cell array: " + str(cell_array))
	print("Cell item array: " + str(cell_item_array))
	print("Stash array: " + str(stash_array))
	print("Stash item array: " + str(stash_item_array))
	
	
	door_status.text = "rng complete"
	
	# splash screen?
	
	# loop
	
	door_status.text = "door closed"
	
	#change background
	
	#player can choose an item to stash
	
	enable_stash_edits = true

	# todo:  tutorial prompts
	
	
	# todo: detect hoverover
	
	# todo: swap fn for fridge
	
	start_btn.pressed.connect(_on_start_btn_pressed)
	
# if only i thought ahead and to abstract these functions... oh well
	
func stash_fill(cell_id, item_no, inventory_index):
	
	var cell_selected: AnimatedSprite2D = get_node(cell_id)
	
	print("calling stash_fill with param " + str(cell_id) + " and " + str(item_no))

	var is_filled: bool = false
	var n_count: int = 0
	
	if cell_item_array[inventory_index] == item_empty:
		return
	elif stash_item_array.has(item_empty) == false:
		# if the stash is full, then swap the item instead with one that the user chooses
		
		# grow the item to show it has been selected
		cell_selected.scale *= 1.25
		
		# change registers
		enable_stash_edits = false
		swap_in_progress = true
		swap_cell_id = cell_id
		swap_cell_type = 1 # i love hardcoding variables
		swap_inventory_index = inventory_index
	
		# handover to _on_stash_input_event or _on_cell_input_event
	else:
		for i in stash_item_array: # i = returns id in stash_item_array
			
			var stash_selected: AnimatedSprite2D = stash_array[n_count]
					
			if is_filled == true:
				# if a slot has already been filled during this function execution, break the return function
				print("Filled - break loop")
				break
			elif i == item_empty and is_filled != true:
				# if a slot is empty, use that slot
				stash_item_array[n_count] = item_no
				stash_selected.frame = item_no 
				cell_item_array[inventory_index] = item_empty
				cell_selected.frame = item_empty
				print("updated stash_selected.frame = " + str(item_no) + " for " + str(stash_selected))
				is_filled = true
				
			n_count += 1
		
		is_filled = false # reset filled variable and end the function
			
func stash_edit(cell_id, inventory_index, viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	print("clicked " + str(cell_id))
	
	var cell_selected: AnimatedSprite2D = get_node(cell_id)
	var item_id: int
	
	# sorry i forgot about zero indexing and its cooked now and not bothered to change each signal manually
	
	if inventory_index < 99: # normal cell
		inventory_index -= 1
		item_id = cell_item_array[inventory_index] 
	
	if item_id != item_empty:
		stash_fill(cell_id, item_id, inventory_index) 
	
func fridge_fill(cell_id, item_no, inventory_index):
	
	# literally just copied and pasted but i reversed everything LMFAO
	
	var stash_selected: AnimatedSprite2D = get_node(cell_id)
	
	print("calling fridge_fill with param " + str(cell_id) + " and " + str(item_no))

	var is_filled: bool = false
	var n_count: int = 0
	
	if stash_item_array[inventory_index] == item_empty:
		return
	elif cell_item_array.has(item_empty) == false:
		# if the stash is full, then swap the item instead with one that the user chooses
		
		# grow the item to show it has been selected
		stash_selected.scale *= 1.25
		
		# change registers
		enable_stash_edits = false
		swap_in_progress = true
		swap_cell_id = cell_id
		swap_cell_type = 0 # i love hardcoding variables
		swap_inventory_index = inventory_index
	
		# handover to _on_stash_input_event or _on_cell_input_event
	else:
		for i in cell_item_array: # i = returns id in cell_item_array
			
			var cell_selected: AnimatedSprite2D = cell_array[n_count]
					
			if is_filled == true:
				# if a slot has already been filled during this function execution, break the return function
				print("Filled - break loop")
				break
			elif i == item_empty and is_filled != true:
				# if a slot is empty, use that slot
				cell_item_array[n_count] = item_no
				cell_selected.frame = item_no 
				stash_item_array[inventory_index] = item_empty
				stash_selected.frame = item_empty
				print("updated stash_selected.frame = " + str(item_no) + " for " + str(cell_selected))
				is_filled = true
				
			n_count += 1
		
		is_filled = false # reset filled variable and end the function
	
func fridge_edit(cell_id, inventory_index, viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var cell_selected: AnimatedSprite2D = get_node(cell_id)
	var item_id: int
	
	# i have now remembered zero indexing
	item_id = stash_item_array[inventory_index]

	print("clicked " + str(cell_id))

	if item_id != item_empty:
		fridge_fill(cell_id, item_id, inventory_index) 
		
func swap_helper(dest_cell_id, dest_inventory_index, dest_cell_type):
	
	# dest_cell_type type: 0 = player clicked on normal cell, 1 = player clicked on stash cell
	var cell_path = dest_cell_id
	if dest_cell_type != 0:
		cell_path = str(dest_cell_id)
		
	var cell_selected: AnimatedSprite2D = get_node(cell_path)
	var swap_cell: AnimatedSprite2D = get_node(swap_cell_id)
	
	var item_id: int
	
	# sorry i forgot about zero indexing and its cooked now 
	# and not bothered to change each signal manually
	
	print("swap helper engaged")
	
	if dest_cell_type == 0: # player clicked on normal cell
		dest_inventory_index -= 1
		
		print("normal cell")
		
		if cell_item_array[dest_inventory_index] == item_empty:
			return
		elif swap_cell_type == 1:
			print("player clicked on normal cell with swap_cell_type = 1")
			print("dest_inventory_index = " + str(dest_inventory_index))
			print("swap_inventory_index = " + str(swap_inventory_index))
			
			var temp = cell_item_array[dest_inventory_index]
			
			cell_item_array[dest_inventory_index] = cell_item_array[swap_inventory_index]
			cell_item_array[swap_inventory_index] = temp
			
			swap_cell.frame = cell_item_array[swap_inventory_index]
			cell_selected.frame = cell_item_array[dest_inventory_index]
			
		else:
			print("player clicked on normal cell")
			print("dest_inventory_index = " + str(dest_inventory_index))
			print("swap_inventory_index = " + str(swap_inventory_index))
			
			var temp = cell_item_array[dest_inventory_index]
			
			cell_item_array[dest_inventory_index] = stash_item_array[swap_inventory_index]
			stash_item_array[swap_inventory_index] = temp
			
			cell_selected.frame = cell_item_array[dest_inventory_index]
			swap_cell.frame = stash_item_array[swap_inventory_index]
		
	elif dest_cell_type == 1: # player clicked on stash cell
		print("stash cell")
		
		if stash_item_array[dest_inventory_index] == item_empty:
			return
		elif swap_cell_type == 0:
			print("player clicked on stash cell with swap_cell_type = 1")
			print("dest_inventory_index = " + str(dest_inventory_index))
			print("swap_inventory_index = " + str(swap_inventory_index))
			
			var temp = stash_item_array[dest_inventory_index]
			
			stash_item_array[dest_inventory_index] = stash_item_array[swap_inventory_index]
			stash_item_array[swap_inventory_index] = temp
			
			swap_cell.frame = stash_item_array[swap_inventory_index]
			cell_selected.frame = stash_item_array[dest_inventory_index]

		else:
			print("player clicked on stash cell")
			print("dest_inventory_index = " + str(dest_inventory_index))
			print("swap_inventory_index = " + str(swap_inventory_index))
			
			var temp = stash_item_array[dest_inventory_index]
			
			stash_item_array[dest_inventory_index] = cell_item_array[swap_inventory_index]
			cell_item_array[swap_inventory_index] = temp
			
			swap_cell.frame = cell_item_array[swap_inventory_index]
			cell_selected.frame = stash_item_array[dest_inventory_index]

	# reset registers
	
	swap_cell.scale *= 0.8
	enable_stash_edits = true
	swap_cell_id = 0
	swap_cell_type = 2
	swap_inventory_index = swap_inventory_index_empty
	swap_in_progress = false

# extra_arg_0 = cell_id
# extra_arg_1 = index in array + 1 for normal cells, index in array + 100 for stash

# i promise this is just as hellish as it looks, particularly with all the redundant conditions becuz i don't have time to figure out which one matters or not 
func _on_cell_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: NodePath, extra_arg_1: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == true and swap_in_progress == false:
			stash_edit(extra_arg_0, extra_arg_1, viewport, event, shape_idx)		
			fridge_grab_sfx.play()
		elif event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == false and swap_in_progress == true:
			swap_helper(extra_arg_0, extra_arg_1, 0)
			fridge_grab_sfx.play()
			

func _on_stash_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: NodePath, extra_arg_1: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == true and swap_in_progress == false:
			fridge_edit(extra_arg_0, extra_arg_1, viewport, event, shape_idx)
		elif event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == false and swap_in_progress == true:
			swap_helper(extra_arg_0, extra_arg_1, 1) 

@export var shake_amount: float = 5.0
@onready var fridge_sprite: AnimatedSprite2D = $FridgeInside
@onready var employee: Sprite2D = $Background/Employee/AnimatedSprite2D
@onready var city: Sprite2D = $Background/City/Sprite2D
@onready var shake_timer = $ShakeTimer
@onready var open_timer = $OpenTimer
@onready var open_sfx_timer = $OpenSFXTimer
@onready var close_sfx_timer = $CloseSFXTimer
@onready var fridge_open_sfx = $FridgeOpenSFX
@onready var fridge_close_sfx = $FridgeCloseSFX
@onready var fridge_buzz_sfx = $FridgeBuzzSFX
@onready var fridge_grab_sfx = $FridgeGrabSFX

const CLOSED = 0
const OPEN = 1
var turn_count: int = 0


# Function that runs when Start is clicked
func _on_start_btn_pressed():
	if turn_count % 2 == 0:
		advance_turn()
		
# Need to get this connected to each employee, need to expand this so 
# only employees of appropriate levels can show up, based on fridges level






########
#func get_random_employee():
	#var frame_count = employee.sprite_frames.get_frame_count("default")
	#var random_frame = randi_range(0, frame_count - 1)
	#print(random_frame)
	#employee.frame = random_frame
##########
# We now pass the current level into the function (e.g. "Level 1")
func summon_employee(current_player_level: String):
	
	# Ask the Autoload for a random employee based on the level
	var chosen_employee = EmployeeManager.summon_employee(current_player_level)
	
	# Safety check: Make sure it actually found someone
	if chosen_employee != null:
		print("Spawned Employee: ", chosen_employee.title)
		
		# Apply the employee's icon directly to your visual node!
		employee.texture = chosen_employee.icon








func advance_turn():
	turn_count += 1
	print("Turn: " + str(turn_count))
	
	if turn_count % 2 != 0:
		shake_timer.start()
		open_sfx_timer.start()
		Globals.refresh_buy_shop.emit()
	else:
		fridge_sprite.frame = CLOSED
		fridge_buzz_sfx.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not shake_timer.is_stopped() and shake_timer.time_left <= 1.0:
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		fridge_sprite.position = fridge_original_position + shake_offset
		for i in cell_array.size():
			cell_array[i].position = cell_original_positions[i] + shake_offset

func _on_shake_timer_timeout() -> void:
	fridge_sprite.position = fridge_original_position
	for i in cell_array.size():
		cell_array[i].position = cell_original_positions[i]
		
	summon_employee(Globals.player_level)
	
	fridge_sprite.frame = OPEN
	
	open_timer.start()
	close_sfx_timer.start()
	fridge_buzz_sfx.play()

func _on_open_timer_timeout() -> void:
	var valid_cells = [] # Only cells that have items
	for i in cell_array.size():
		if cell_item_array[i] != item_empty:
			valid_cells.append(i)
			
	if not valid_cells.is_empty():
		var random_idx = randi_range(0, valid_cells.size() - 1)
		var chosen_idx = valid_cells[random_idx]
		cell_item_array[chosen_idx] = item_empty
		cell_array[chosen_idx].frame = item_empty
		
	advance_turn()

func _on_open_sfx_timer_timeout() -> void:
	fridge_open_sfx.play()
	
func _on_close_sfx_timer_timeout() -> void:
	fridge_close_sfx.play()
	
func _on_temp_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			advance_level()
	
func advance_level():
	level += 1
	print("Level: " + str(level))
	city.position.y += 200

# Shop updates

func _on_inventory_update(id: int, cost: int, store_array_index: int) -> void: # this is only to be used by buy-shop
	
	var has_filled: bool = false
	
	var n_i: int = 0
	var n_j: int = 0
	 
	for i in stash_item_array:
		if has_filled == true:
			break
		elif i == item_empty and has_filled == false:
			stash_item_array[n_i] = id
			stash_array[n_i].frame = id
			has_filled = true
			break
		n_i += 1

	for j in cell_item_array:
		if has_filled == true:
			break
		elif j == item_empty and has_filled == false:
			cell_item_array[n_j] = id
			cell_array[n_j].frame = id
			has_filled = true
			break
		n_j += 1
			
	if has_filled == false:
		print("No space in inventory")	# need to handle this with notifications
	elif has_filled == true:
		Globals.player_bal -= cost	
		Globals.remove_item_from_shop.emit(store_array_index)
		has_filled = false # just in case yknow
		
func _on_action_sale_in_inventory(id: int, cost: int, combined_inventory_index: int) -> void:
	if combined_inventory_index <= 5:	# in fridge
		item_update_handler(false, combined_inventory_index, item_empty)
	else:								# in stash
		item_update_handler(true, combined_inventory_index - 6, item_empty)
		
	Globals.player_bal += cost	
	Globals.refresh_sell_shop.emit()
	
func item_update_handler(is_stash: bool, index: int, update_to_item_id: int) -> void:
	if is_stash == false:	# in fridge
		cell_item_array[index] = update_to_item_id
		cell_array[index].frame = cell_item_array[index]
	elif is_stash == true:
		stash_item_array[index] = update_to_item_id
		stash_array[index].frame = stash_item_array[index] 


# it works right? no complaining~
