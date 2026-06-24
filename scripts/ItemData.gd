extends Resource
class_name ItemData # This makes it show up in Godot's create menu!

@export var item_name: String = "New Item"
@export var cost: int = 0
@export var icon: Texture2D # You can drag and drop images directly into this!
@export_multiline var description: String = ""
