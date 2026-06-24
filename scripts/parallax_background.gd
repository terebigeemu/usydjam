extends ParallaxBackground

# screen size
var viewport_size = Vector2(1920, 1080)

@onready var parallax_layer: ParallaxLayer = $ParallaxLayer
@onready var parallax_layer_2: ParallaxLayer = $ParallaxLayer2


func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x = event.position.x
		var mouse_y = event.position.y
		
		var relative_x = (mouse_x - (viewport_size.x/2)) / (viewport_size.x/2)
		var relative_y = (mouse_y - (viewport_size.y/2)) / (viewport_size.y/2)
		
		parallax_layer.motion_offset.x = 8 * relative_x
		parallax_layer.motion_offset.y = 8 * relative_y

		parallax_layer_2.motion_offset.x = 4 * relative_x
		parallax_layer_2.motion_offset.y = 4 * relative_y
