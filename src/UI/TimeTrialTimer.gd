extends NinePatchRect

func _process(delta):
	if TimeTrial.time_trial: $Label.text = TimeTrial.elapsed_time
