extends Node2D

@onready var employee: Parallax2D = $Employee
@onready var office: Parallax2D = $Office

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_viewport().get_mouse_position()
		employee.scroll_offset = 0.01 * mouse_pos
		office.scroll_offset = 0.005 * mouse_pos
