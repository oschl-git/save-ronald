extends Control

export var level_number : int = 0
export var final_chapter_level : = false
export var final_level : = false
export var next_level: PackedScene

func _ready():
	var exitdoor = get_node("../../Objects/ExitDoor")
	exitdoor.connect("levelexit", self, "player_exit_finished")
	
	Auto.current_level = level_number

func _get_configuration_warning():
	return "Need to input next level" if not next_level else ""

func player_exit_finished():
	if GameSaving.user_data["unlocked_levels"] < level_number:
		GameSaving.user_data["unlocked_levels"] = level_number
		GameSaving.save_data()
	
	if TimeTrial.time_trial:
		if TimeTrial.level:
			transition()
			yield(get_tree().create_timer(.5, false), "timeout")
			get_tree().change_scene("res://src/UI/TimeTrialFinished.tscn")
		
		elif TimeTrial.chapter:
			if final_chapter_level:
				transition()
				yield(get_tree().create_timer(.5, false), "timeout")
				get_tree().change_scene("res://src/UI/TimeTrialFinished.tscn")
			else: 
				transition()
				yield(get_tree().create_timer(.5, false), "timeout")
				get_tree().change_scene_to(next_level)
		
		elif TimeTrial.game:
			if final_level:
				transition()
				yield(get_tree().create_timer(.5, false), "timeout")
				get_tree().change_scene("res://src/UI/TimeTrialFinished.tscn")
			else: 
				transition()
				yield(get_tree().create_timer(.5, false), "timeout")
				get_tree().change_scene_to(next_level)
	else:
		$Control/Continue.grab_focus()
		visible = true
		$ui1.play()
		$AnimationPlayer.play("enter")

func _on_Continue_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(next_level)

func _on_Restart_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene("res://src/UI/MainMenu.tscn")

func transition():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")
