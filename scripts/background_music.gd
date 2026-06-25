extends AudioStreamPlayer2D

func fade_audio(target_db: float, duration: float):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", target_db, duration).set_trans(Tween.TRANS_SINE)
