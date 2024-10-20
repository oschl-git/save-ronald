extends Control

func _ready():
	$Content/logo/version.text = Auto.VERSION
	transition_exit()
	yield(get_tree().create_timer(.5, false), "timeout")
	$AnimationPlayer.play("entrance")

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		$button_press.play()
		transition_enter()
		yield(get_tree().create_timer(.5, false), "timeout")
		get_tree().change_scene("res://src/UI/MainMenu.tscn")

func transition_enter():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")

func transition_exit():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("exit")
