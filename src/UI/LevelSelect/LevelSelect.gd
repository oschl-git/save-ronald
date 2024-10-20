extends Control

export var button1 : PackedScene
export var button2 : PackedScene
export var button3 : PackedScene
export var button4 : PackedScene
export var button5 : PackedScene
export var button6 : PackedScene
export var button7 : PackedScene
export var button8 : PackedScene

export var low_level_interval : int
export var high_level_interval : int

onready var disabled_selected_texture = load("res://assets/UI/level_button_disabled_selected.png")

func _ready():
	$LevelButtons/button1.grab_focus()
	lock_buttons()
	transition_exit()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$button_press.play()
		transition_enter()
		yield(get_tree().create_timer(.5, false), "timeout")
		get_tree().change_scene("res://src/UI/MainMenu.tscn")


func _on_button1_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button1)

func _on_button2_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button2)

func _on_button3_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button3)

func _on_button4_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button4)

func _on_button5_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button5)

func _on_button6_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button6)

func _on_button7_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button7)

func _on_button8_pressed():
	$button_press.play()
	transition_enter()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene_to(button8)

func transition_enter():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")

func transition_exit():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("exit")

func lock_buttons():
	if (low_level_interval + 0) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button1.disabled = true
		$LevelButtons/button1.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button1/Label.visible = false
	if (low_level_interval + 1) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button2.disabled = true
		$LevelButtons/button2.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button2/Label.visible = false
	if (low_level_interval + 2) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button3.disabled = true
		$LevelButtons/button3.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button3/Label.visible = false
	if (low_level_interval + 3) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button4.disabled = true
		$LevelButtons/button4.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button4/Label.visible = false
	if (low_level_interval + 4) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button5.disabled = true
		$LevelButtons/button5.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button5/Label.visible = false
	if (low_level_interval + 5) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button6.disabled = true
		$LevelButtons/button6.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button6/Label.visible = false
	if (low_level_interval + 6) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button7.disabled = true
		$LevelButtons/button7.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button7/Label.visible = false
	if (low_level_interval + 7) > (GameSaving.user_data["unlocked_levels"] + 1):
		$LevelButtons/button8.disabled = true
		$LevelButtons/button8.set_focused_texture(disabled_selected_texture)
		$LevelButtons/button8/Label.visible = false
