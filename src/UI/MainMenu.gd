extends Control

signal openoptions()

onready var levelscreen = preload("res://src/UI/LevelSelect/LevelSelect1.tscn")

var playbuttons : = false
var timetrialbuttons : = false
export var menu_music : AudioStreamOGGVorbis

func _ready():
	MusicManager.change_music(menu_music)
		
	enable_buttons()
	$Menu/Buttons/Play.grab_focus() #Selects the first button
	$logo/version.text = Auto.VERSION
	entrancetransition()
	$AnimationPlayer.play("entrance")
	$Options.connect("optionsclosed", self, "on_options_closed")
	
	if GameSaving.user_data["unlocked_levels"] == 0:
		$Menu/PlayButtons/Continue/Label.text = "new game"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if playbuttons:
			$button_press.play()
			disable_play_buttons()
			$Menu/PlayButtons.visible = false
			enable_buttons()
			$Menu/Buttons.visible = true
			$Menu/Buttons/Play.grab_focus()
			playbuttons = false
		if timetrialbuttons:
			$button_press.play()
			disable_timetrial_buttons()
			$Menu/TimeTrialButtons.visible = false
			enable_play_buttons()
			$Menu/PlayButtons.visible = true
			$Menu/PlayButtons/TimeTrial.grab_focus()
			timetrialbuttons = false
			playbuttons = true

#Focus animations
func _on_Play_focus_entered():
	$Menu/ButtonInfo.text = "Play the game."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Options_focus_entered():
	$Menu/ButtonInfo.text = "Modify the game settings."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Credits_focus_entered():
	$Menu/ButtonInfo.text = "Learn who created this game."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Exit_focus_entered():
	$Menu/ButtonInfo.text = "Exit the game."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Continue_focus_entered():
	if GameSaving.user_data["unlocked_levels"] == 0:
		$Menu/ButtonInfo.text = "Start from the beginning."
		$Menu/PlayButtons/Continue/Label.text = "new game"
	else: $Menu/ButtonInfo.text = "Continue saved game."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_LevelSelect_focus_entered():
	$Menu/ButtonInfo.text = "Select from any unlocked level."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_TimeTrial_focus_entered():
	$Menu/ButtonInfo.text = "A time trial mode for speedrunners."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Level_focus_entered():
	$Menu/ButtonInfo.text = "Time trial a single level."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_FullGame_focus_entered():
	$Menu/ButtonInfo.text = "Time trial the entire game."
	$Menu/ButtonInfoAnim.play("labelchange")
func _on_Highscores_focus_entered():
	$Menu/ButtonInfo.text = "See your best times."
	$Menu/ButtonInfoAnim.play("labelchange")

#Button behaviour
func _on_Play_pressed():
	TimeTrial.time_trial = false
	TimeTrial.level = false
	TimeTrial.chapter = false
	TimeTrial.game = false
	
	$button_press.play()
	disable_buttons()
	$Menu/Buttons.visible = false
	enable_play_buttons()
	$Menu/PlayButtons.visible = true
	$Menu/PlayButtons/Continue.grab_focus()
	playbuttons = true

func _on_Options_pressed():
	$AnimationPlayer.play("exit")
	$Menu.visible = false
	emit_signal("openoptions")

func _on_Credits_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene("res://src/UI/Credits.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Continue_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	if GameSaving.levels.size() <= GameSaving.user_data["unlocked_levels"]: get_tree().change_scene(GameSaving.levels[GameSaving.user_data["unlocked_levels"] - 1])
	else: get_tree().change_scene(GameSaving.levels[GameSaving.user_data["unlocked_levels"]])
	#This ensures that the method will not call for a nonexistent Array index.

func _on_LevelSelect_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(levelscreen)

func _on_TimeTrial_pressed():
	$button_press.play()
	disable_play_buttons()
	$Menu/PlayButtons.visible = false
	enable_timetrial_buttons()
	$Menu/TimeTrialButtons.visible = true
	$Menu/TimeTrialButtons/Level.grab_focus()
	playbuttons = false
	timetrialbuttons = true

func _on_Level_pressed():
	TimeTrial.time_trial = true
	TimeTrial.level = true
	TimeTrial.game = false
	TimeTrial.chapter = false
	
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(levelscreen)

func _on_FullGame_pressed():
	TimeTrial.start_time_trial_with_delay()
	TimeTrial.time_trial = true
	TimeTrial.game = true
	TimeTrial.level = false
	TimeTrial.chapter = false
	
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene(GameSaving.levels[0])
	
func _on_Highscores_pressed():
	$button_press.play()
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene("res://src/UI/Highscores.tscn")


func on_options_closed():
	$Menu.visible = true
	$AnimationPlayer.play("entrance")
	$Menu/Buttons/Play.grab_focus() #Selects the first button

func transition():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")

func entrancetransition():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("exit")

func disable_buttons():
	$Menu/Buttons/Play.focus_mode = FOCUS_NONE
	$Menu/Buttons/Options.focus_mode = FOCUS_NONE
	$Menu/Buttons/Credits.focus_mode = FOCUS_NONE
	$Menu/Buttons/Exit.focus_mode = FOCUS_NONE
func enable_buttons():
	$Menu/Buttons/Play.focus_mode = FOCUS_ALL
	$Menu/Buttons/Options.focus_mode = FOCUS_ALL
	$Menu/Buttons/Credits.focus_mode = FOCUS_ALL
	$Menu/Buttons/Exit.focus_mode = FOCUS_ALL

func disable_play_buttons():
	$Menu/PlayButtons/Continue.focus_mode = FOCUS_NONE
	$Menu/PlayButtons/LevelSelect.focus_mode = FOCUS_NONE
	$Menu/PlayButtons/TimeTrial.focus_mode = FOCUS_NONE
func enable_play_buttons():
	$Menu/PlayButtons/Continue.focus_mode = FOCUS_ALL
	$Menu/PlayButtons/LevelSelect.focus_mode = FOCUS_ALL
	$Menu/PlayButtons/TimeTrial.focus_mode = FOCUS_ALL

func disable_timetrial_buttons():
	$Menu/TimeTrialButtons/Level.focus_mode = FOCUS_NONE
	$Menu/TimeTrialButtons/Highscores.focus_mode = FOCUS_NONE
	$Menu/TimeTrialButtons/FullGame.focus_mode = FOCUS_NONE
func enable_timetrial_buttons():
	$Menu/TimeTrialButtons/Level.focus_mode = FOCUS_ALL
	$Menu/TimeTrialButtons/Highscores.focus_mode = FOCUS_ALL
	$Menu/TimeTrialButtons/FullGame.focus_mode = FOCUS_ALL
