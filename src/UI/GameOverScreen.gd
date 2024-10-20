extends Control

func _ready():
	var player = get_node("../../Objects/Player")
	player.connect("playerdeath", self, "player_died")
	
func player_died():
	if TimeTrial.time_trial:
		if TimeTrial.level:
			TimeTrial.stop_time_trial()
			TimeTrial.time_trial = true
		
		transition()
		yield(get_tree().create_timer(.5, false), "timeout")
		get_tree().reload_current_scene()
	else:
		visible = true
		yield(get_tree().create_timer(.5, false), "timeout")
		$Control/Restart.grab_focus()
		$AnimationPlayer.play("enter")
	
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
	yield(get_tree().create_timer(.5, false), "timeout")
