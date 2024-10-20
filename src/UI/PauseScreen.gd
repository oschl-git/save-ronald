extends Control

var new_pause_state : bool
var timetrial_menu : = false
var canpause : = true
var optionsopened : = false

var player

signal openoptions()

func _ready():
	player = get_node("../../Objects/Player")
	player.connect("playerdeath", self, "player_died")
	player.pausescreen = self
	
	var exitdoor = get_node("../../Objects/ExitDoor")
	exitdoor.connect("levelexit", self, "player_exit_finished")
	
	$Options.connect("optionsclosed", self, "on_options_closed")

func _input(event):
	if event.is_action_pressed("pause") and optionsopened == false:
		pause()
	if event.is_action_pressed("restart"):
		if TimeTrial.time_trial: time_trial_restart()
		else: restart()
	
func pause():
	if TimeTrial.time_trial:
		if !timetrial_menu:
			timetrial_menu = true
			$ui1.play()
			$AnimationPlayer.play("timetrial_enter")
			enable_timetrial_buttons()
			$TimeTrial/TimeTrialRestart.grab_focus()
			visible = true
			$TimeTrial.visible = true
			player.canmove = false
			player.velocity.x = 0
		else:
			timetrial_menu = false
			if !player.stunned: player.canmove = true
			$ui2.play()
			$AnimationPlayer.play("timetrial_exit")
			disable_timetrial_buttons()
			yield(get_tree().create_timer(.5), "timeout")
			visible = false
			$TimeTrial.visible = false
	
	elif canpause:
		new_pause_state = not get_tree().paused
		if new_pause_state:
			$ui1.play()
			$AnimationPlayer.play("enter")
			enable_buttons()
			$Pause/Resume.grab_focus()
			visible = true
			get_tree().paused = true
			$Pause.visible = true
		else:
			disable_buttons() 
			get_tree().paused = false
			$ui2.play()
			$AnimationPlayer.play("exit")
			yield(get_tree().create_timer(.5), "timeout")
			visible = false
			$Pause.visible = false
	
func _on_Resume_pressed(): if new_pause_state: pause()

func _on_Restart_pressed(): restart()

func _on_Options_pressed():
	disable_buttons()
	optionsopened = true
	emit_signal("openoptions")
	$AnimationPlayer.play("exitwobackground")
	yield(get_tree().create_timer(.5, false), "timeout")
	$Pause.visible = false

func _on_MainMenu_pressed():
	if new_pause_state:
		$button_press.play()
		transition()
		get_tree().paused = false
		yield(get_tree().create_timer(.5, false), "timeout")
		get_tree().change_scene("res://src/UI/MainMenu.tscn")
		
func _on_TimeTrialRestart_pressed():
	$button_press.play()
	time_trial_restart()

func _on_TimeTrialResume_pressed():
	if timetrial_menu:
		pause()

func _on_TimeTrialEnd_pressed():
	$button_press.play()
	TimeTrial.stop_time_trial()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene("res://src/UI/MainMenu.tscn")

func player_died():
	canpause = false
	
func player_exit_finished():
	canpause = false
	
func restart():
	if new_pause_state:
		get_tree().paused = false
	canpause = false
	transition()
	$button_press.play()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().reload_current_scene()

func time_trial_restart():
	if TimeTrial.level:
		TimeTrial.stop_time_trial()
		TimeTrial.time_trial = true
		
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().reload_current_scene()

func transition():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")

func on_options_closed():
	$Pause.visible = true
	enable_buttons()
	$AnimationPlayer.play("enterwobackground")
	$Pause/Resume.grab_focus()
	yield(get_tree().create_timer(.1), "timeout")
	optionsopened = false

func disable_buttons():
	$Pause/Resume.focus_mode = FOCUS_NONE
	$Pause/Restart.focus_mode = FOCUS_NONE
	$Pause/Options.focus_mode = FOCUS_NONE
	$Pause/MainMenu.focus_mode = FOCUS_NONE
func enable_buttons():
	$Pause/Resume.focus_mode = FOCUS_ALL
	$Pause/Restart.focus_mode = FOCUS_ALL
	$Pause/Options.focus_mode = FOCUS_ALL
	$Pause/MainMenu.focus_mode = FOCUS_ALL
	
func disable_timetrial_buttons():
	$TimeTrial/TimeTrialRestart.focus_mode = FOCUS_NONE
	$TimeTrial/TimeTrialResume.focus_mode = FOCUS_NONE
	$TimeTrial/TimeTrialEnd.focus_mode = FOCUS_NONE
func enable_timetrial_buttons():
	$TimeTrial/TimeTrialRestart.focus_mode = FOCUS_ALL
	$TimeTrial/TimeTrialResume.focus_mode = FOCUS_ALL
	$TimeTrial/TimeTrialEnd.focus_mode = FOCUS_ALL
