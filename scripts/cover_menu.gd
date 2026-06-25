extends Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	Globals.release_menu.connect(_on_release_menu)
	Globals.block_menu.connect(_on_block_menu)
	pass # Replace with function body.

func _on_release_menu() -> void:
	self.visible = false
	
func _on_block_menu() -> void:
	self.visible = true
	
