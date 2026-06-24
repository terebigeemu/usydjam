# author: adrian
# don't ask what i'm doing as i have gone insane

extends Node

@onready var door_status: Label = $DoorStatus
@onready var cell1: AnimatedSprite2D = $Area1/Cell1
@onready var cell2: AnimatedSprite2D = $Area2/Cell2
@onready var cell3: AnimatedSprite2D = $Area3/Cell3
@onready var cell4: AnimatedSprite2D = $Area4/Cell4
@onready var cell5: AnimatedSprite2D = $Area5/Cell5
@onready var cell6: AnimatedSprite2D = $Area6/Cell6
@onready var stash100: AnimatedSprite2D = $Stash100/Cell100
@onready var stash101: AnimatedSprite2D = $Stash101/Cell101
@onready var stash102: AnimatedSprite2D = $Stash102/Cell102

var rng = RandomNumberGenerator.new()
var turn_counter = 0
var level = 0

const swap_inventory_index_empty: int = 69420 # this should break the code if used

# registers

var enable_stash_edits = false
var swap_in_progress = false
var swap_cell_id
var swap_inventory_index: int = swap_inventory_index_empty

# item values (should be equal to frame ids)
# should initially be empty

const item_empty: int = 157

var item1: int = item_empty
var item2: int = item_empty
var item3: int = item_empty
var item4: int = item_empty
var item5: int = item_empty
var item6: int = item_empty

var item100: int = item_empty
var item101: int = item_empty
var item102: int = item_empty

# _array		= contains the NodePath
# _item_array	= contains the item ID (usually congruent with the spritesheet frame ID)
# cell_array and cell_item_array should generally never diverge except for
# momentary instances where the frames of a sprite might need to change

@onready var cell_array = [cell1, cell2, cell3, cell4, cell5, cell6]
@onready var cell_item_array = [item1, item2, item3, item4, item5, item6]

@onready var stash_array = [stash100, stash101, stash102]
@onready var stash_item_array = [item100, item101, item102]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# call cutscene? can be done in a diff script
	
	door_status.text = "init"
	
	# INIT
	
	# randomly generate cells 1-6
	
	# background should be person putting in food

	
	var n_stash: int = 0
	var n_cell: int = 0

	for i in stash_array:
		i.frame = stash_item_array[n_stash]
		n_stash += 1
	
	for i in cell_array:
		i.visible = false
		
	#await get_tree().create_timer(0.5).timeout
	
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
	var cell_selected: AnimatedSprite2D = get_node(cell_id)
	var item_id: int

	print("clicked " + str(cell_id))
	
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
	elif stash_item_array.has(item_empty) == false:
		# if the stash is full, then swap the item instead with one that the user chooses
		
		# grow the item to show it has been selected
		stash_selected.scale *= 1.25
		
		# change registers
		enable_stash_edits = false
		swap_in_progress = true
		swap_cell_id = cell_id
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
	
	var cell_selected: AnimatedSprite2D = get_node(dest_cell_id)
	var swap_cell: AnimatedSprite2D = get_node(swap_cell_id)
	
	var item_id: int
	
	# sorry i forgot about zero indexing and its cooked now 
	# and not bothered to change each signal manually
	
	print("swap helper engaged")
	
	if dest_cell_type == 0: # player clicked on normal cell
		dest_inventory_index -= 1

		if cell_item_array[dest_inventory_index] == item_empty:
			return
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
		
		if stash_item_array[dest_inventory_index] == item_empty:
			return
		
		else:
			print("player clicked on stash cell")
			print("dest_inventory_index = " + str(dest_inventory_index))
			print("swap_inventory_index = " + str(swap_inventory_index))
			
			var temp = stash_item_array[dest_inventory_index]
			
			stash_item_array[dest_inventory_index] = cell_item_array[swap_inventory_index]
			cell_item_array[swap_inventory_index] = temp

			cell_selected.frame = stash_item_array[dest_inventory_index]
			swap_cell.frame = cell_item_array[swap_inventory_index]

	# reset registers
	
	swap_cell.scale *= 0.8
	enable_stash_edits = true
	swap_cell_id = 0;
	swap_inventory_index = swap_inventory_index_empty
	swap_in_progress = false

# extra_arg_0 = cell_id
# extra_arg_1 = index in array + 1 for normal cells, index in array + 100 for stash
func _on_cell_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: NodePath, extra_arg_1: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == true and swap_in_progress == false:
			stash_edit(extra_arg_0, extra_arg_1, viewport, event, shape_idx)		
		elif event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == false and swap_in_progress == true:
			swap_helper(extra_arg_0, extra_arg_1, 0)
			

func _on_stash_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: NodePath, extra_arg_1: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == true and swap_in_progress == false:
			fridge_edit(extra_arg_0, extra_arg_1, viewport, event, shape_idx)
		elif event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == false and swap_in_progress == true:
			swap_helper(extra_arg_0, extra_arg_1, 1) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
