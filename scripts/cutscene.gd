extends AnimatedSprite2D

@onready var cutscene4_label = $"../Cutscene4Label"
@onready var cutscene5_label = $"../Cutscene5Label"
@onready var cutscene5_label2 = $"../Cutscene5Label2"
@onready var input_blocker = $"../InputBlocker"

var cutscene_finished: bool = false

func _on_frame_changed() -> void:
	if frame == 3:
		cutscene4_label.show()
	elif frame == 4:
		cutscene4_label.hide()
		cutscene5_label.show()
		cutscene5_label2.show()
		
		cutscene5_label2.modulate.a = 0.0
	
		var fade_tween = create_tween()
		
		fade_tween.tween_property(cutscene5_label2, "modulate:a", 1.0, 1.0).set_delay(3.0)

func _on_animation_finished() -> void:
	cutscene_finished = true

func _on_input_blocker_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and cutscene_finished:
			self.hide()
			input_blocker.hide()
			cutscene5_label.hide()
			cutscene5_label2.hide()
