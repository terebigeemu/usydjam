extends Node

var player_bal: int = 10

@onready var cell1: AnimatedSprite2D = get_node("../Fridge/Area1/Cell1")
@onready var cell2: AnimatedSprite2D = get_node("../Fridge/Area2/Cell2")
@onready var cell3: AnimatedSprite2D = get_node("../Fridge/Area3/Cell3")
@onready var cell4: AnimatedSprite2D = get_node("../Fridge/Area4/Cell4")
@onready var cell5: AnimatedSprite2D = get_node("../Fridge/Area5/Cell5")
@onready var cell6: AnimatedSprite2D = get_node("../Fridge/Area6/Cell6")
@onready var stash100: AnimatedSprite2D = get_node("../Fridge/UI/Stash100/Cell100")
@onready var stash101: AnimatedSprite2D = get_node("../Fridge/UI/Stash101/Cell101")
@onready var stash102: AnimatedSprite2D = get_node("../Fridge/UI/Stash102/Cell102")

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

@onready var cell_array = [cell1, cell2, cell3, cell4, cell5, cell6]
@onready var cell_item_array = [item1, item2, item3, item4, item5, item6]

@onready var stash_array = [stash100, stash101, stash102]
@onready var stash_item_array = [item100, item101, item102]

signal add_purchase_to_inventory(id, cost, store_array_index)
signal remove_item_from_shop(store_array_index)
