extends Control

func _ready():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("exit")
	yield(get_tree().create_timer(.4, false), "timeout")
	$AnimationPlayer.play("entrance")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			return_to_main()
	if event is InputEventJoypadButton:
		if event.pressed:
			return_to_main()

func return_to_main():
	transition()
	yield(get_tree().create_timer(.5, false), "timeout")
	get_tree().change_scene("res://src/UI/MainMenu.tscn")

func transition():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")
