extends Resource
class_name ItemData # This makes it show up in Godot's create menu!

@export var item_id: int = 0
@export var item_name: String = ""
@export var attrb: String = ""
@export var cost: int = 0
@export var icon: Texture2D # You can drag and drop images directly into this!
