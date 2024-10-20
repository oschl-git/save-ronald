extends Control

func _ready():
	TimeTrial.stop_time_trial()
	$Buttons/Retry.grab_focus()
	
	var record : = false
	var new_time : = false
	
	var details : String
	
	if TimeTrial.level:
		if not Auto.current_level in GameSaving.user_data["level_times"]: new_time = true
		elif TimeTrial.elapsed_ms < GameSaving.user_data["level_times"][Auto.current_level]: record = true
		
		if record: 
			$NewRecord.visible = true
			details = ("\n\n" + Auto.current_level_name
			+ "\nnew best time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\nprevious time: " + TimeTrial.convert_ms_to_time(GameSaving.user_data["level_times"][Auto.current_level])
			+ "\ngame version: " + Auto.VERSION)
		elif new_time:
			details = (Auto.current_level_name
			+ "\nyour time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\ngame version: " + Auto.VERSION)
		else:
			details = (Auto.current_level_name
			+ "\nyour time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\nbest time: " + TimeTrial.convert_ms_to_time(GameSaving.user_data["level_times"][Auto.current_level])
			+ "\ngame version: " + Auto.VERSION)
		
		if record or new_time:
			GameSaving.user_data["level_times"][Auto.current_level] = TimeTrial.elapsed_ms
			GameSaving.save_data()
	
	elif TimeTrial.chapter: pass
	
	if TimeTrial.game:
		if GameSaving.user_data["full_game_time"] == 0: new_time = true
		elif TimeTrial.elapsed_ms < GameSaving.user_data["full_game_time"]: record = true
		
		if record: 
			$NewRecord.visible = true
			details = ("\n\n" + "FULL GAME TIME TRIAL"
			+ "\nnew best time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\nprevious time: " + TimeTrial.convert_ms_to_time(GameSaving.user_data["full_game_time"])
			+ "\ngame version: " + Auto.VERSION)
		elif new_time:
			details = ("FULL GAME TIME TRIAL"
			+ "\nyour time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\ngame version: " + Auto.VERSION)
		else:
			details = ("FULL GAME TIME TRIAL"
			+ "\nyour time: " + TimeTrial.convert_ms_to_time(TimeTrial.elapsed_ms)
			+ "\nbest time: " + TimeTrial.convert_ms_to_time(GameSaving.user_data["full_game_time"])
			+ "\ngame version: " + Auto.VERSION)
		
		if record or new_time:
			GameSaving.user_data["full_game_time"] = TimeTrial.elapsed_ms
			GameSaving.save_data()
		
	$Details.text = details
	


func _on_Retry_pressed():
	$button_press.play()
	TimeTrial.start_time_trial()
	if TimeTrial.level: get_tree().change_scene(GameSaving.levels[Auto.current_level - 1])
	elif TimeTrial.game: get_tree().change_scene(GameSaving.levels[0])

func _on_MainMenu_pressed():
	$button_press.play()
	get_tree().change_scene("res://src/UI/MainMenu.tscn")
