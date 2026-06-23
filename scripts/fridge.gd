# author: adrian

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
var enable_stash_edits = false

# item values (should be equal to frame ids)

# item id 157 = empty

var item1: int
var item2: int
var item3: int
var item4: int
var item5: int
var item6: int

var item100: int
var item101: int
var item102: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# call cutscene? can be done in a diff script
	
	door_status.text = "init"
	
	# randomly generate cells 1-6
	
	# background should be person putting in food
	
	var cell_array = [cell1, cell2, cell3, cell4, cell5, cell6]
	var cell_item_array = [item1, item2, item3, item4, item5, item6]
	
	var stash_array = [stash100, stash101, stash102]
	var stash_item_array = [item100, item101, item102]
	
	var n_stash: int 
	var n_cell: int

	for i in stash_array:
		n_stash += 0
		i.frame = stash_item_array[n_stash]
		i.visible = false
	
	for i in cell_array:
		i.visible = false
		
	await get_tree().create_timer(0.5).timeout
	
	for i in cell_array:
		n_cell += 0
		await get_tree().create_timer(0.05).timeout
		cell_item_array[n_cell] = rng.randi_range(0, 45)
		i.frame = cell_item_array[n_cell]
		i.visible = true
	
	door_status.text = "rng complete"
	
	# splash screen?
	
	# loop
	
	door_status.text = "door closed"
	
	#change background
	
	#player can choose an item to stash
	
	enable_stash_edits = true

	# todo:  tutorial prompts
	
	
	#todo: detect hoverover
	
func stash_edit(cell_id, viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var cell_selected: AnimatedSprite2D = get_node(cell_id)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and enable_stash_edits == true:
			print("clicked " + str(cell_id))
			cell_selected.frame = 157 
			
	pass

	# extra_arg_0 = cell_id
func _on_cell_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: NodePath) -> void:
	stash_edit(extra_arg_0, viewport, event, shape_idx)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
