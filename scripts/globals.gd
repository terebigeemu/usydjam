extends Node

var player_bal: int = 10
var player_level: String = "Employee"

@onready var cell1: AnimatedSprite2D = get_node("../Fridge/Area1/Cell1")
@onready var cell2: AnimatedSprite2D = get_node("../Fridge/Area2/Cell2")
@onready var cell3: AnimatedSprite2D = get_node("../Fridge/Area3/Cell3")
@onready var cell4: AnimatedSprite2D = get_node("../Fridge/Area4/Cell4")
@onready var cell5: AnimatedSprite2D = get_node("../Fridge/Area5/Cell5")
@onready var cell6: AnimatedSprite2D = get_node("../Fridge/Area6/Cell6")
@onready var stash100: AnimatedSprite2D = get_node("../Fridge/UI/Stash100/Cell100")
@onready var stash101: AnimatedSprite2D = get_node("../Fridge/UI/Stash101/Cell101")
@onready var stash102: AnimatedSprite2D = get_node("../Fridge/UI/Stash102/Cell102")

@onready var stash100_Area2D: Area2D = get_node("../Fridge/UI/Stash100")
@onready var stash101_Area2D: Area2D = get_node("../Fridge/UI/Stash101")
@onready var stash102_Area2D: Area2D = get_node("../Fridge/UI/Stash102")

@onready var area1: Area2D = get_node("../Fridge/Area1")
@onready var area2: Area2D = get_node("../Fridge/Area2")
@onready var area3: Area2D = get_node("../Fridge/Area3")
@onready var area4: Area2D = get_node("../Fridge/Area4")
@onready var area5: Area2D = get_node("../Fridge/Area5")
@onready var area6: Area2D = get_node("../Fridge/Area6")

@onready var error_sfx = get_node("../Fridge/UI/ErrorSFX")
@onready var home_sfx = get_node("../Fridge/UI/HomeSFX")
@onready var menu_sfx = get_node("../Fridge/UI/MenuSFX")
@onready var buy_sell_sfx = get_node("../Fridge/BuySellSFX")

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

var tooltips_enabled: bool = false;

@onready var cell_array = [cell1, cell2, cell3, cell4, cell5, cell6]
@onready var cell_item_array = [item1, item2, item3, item4, item5, item6]

@onready var stash_array = [stash100, stash101, stash102]
@onready var stash_item_array = [item100, item101, item102]

signal add_purchase_to_inventory(id, cost, store_array_index)
signal action_sale_in_inventory(id, cost, combined_inventory_index)
signal remove_item_from_shop(store_array_index)
signal refresh_sell_shop
signal refresh_buy_shop
signal employee_takes_from_fridge(employee_title)
signal release_menu()
signal block_menu()
signal update_slot_tooltip_signal(i, id)
signal check_if_game_over()

var affinity_to_add: int = 0;
var affinity_to_add_hasbeenadded: bool = true;

var chosen_employee

func update_pickable_status() -> void:
	var n_i: int = 0
	for i in stash_array:
		if stash_item_array[n_i] != Globals.item_empty:
			individual_stash_pickable_handler(true, n_i)
		else:
			individual_stash_pickable_handler(false, n_i)
		n_i += 1
		
	var n_j: int = 0
	for j in cell_array:
		if cell_item_array[n_j] != Globals.item_empty:
			individual_cell_pickable_handler(true, n_j)
		else:
			individual_cell_pickable_handler(false, n_j)
		n_j += 1

func stash_pickable_handler(is_pickable: bool) -> void:
	stash100_Area2D.input_pickable = is_pickable
	stash101_Area2D.input_pickable = is_pickable
	stash102_Area2D.input_pickable = is_pickable
	
func individual_stash_pickable_handler(is_pickable: bool, index: int) -> void:
	match index:
		0:
			stash100_Area2D.input_pickable = is_pickable
		1:
			stash101_Area2D.input_pickable = is_pickable
		2:
			stash102_Area2D.input_pickable = is_pickable
			
func individual_cell_pickable_handler(is_pickable: bool, index: int) -> void:
	match index:
		0:
			area1.input_pickable = is_pickable
		1:
			area2.input_pickable = is_pickable
		2:
			area3.input_pickable = is_pickable
		3:
			area4.input_pickable = is_pickable
		4:
			area5.input_pickable = is_pickable
		5:
			area6.input_pickable = is_pickable
