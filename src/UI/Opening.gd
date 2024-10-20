extends Control

onready var mainmenu = preload("res://src/UI/MainMenu.tscn")
var changingscene : = false

func _ready():
	yield(get_tree().create_timer(.5), "timeout")
	$part1.visible = true
	$AnimationPlayer.play("oschl_entrance")
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("oschl_exit")
	yield(get_tree().create_timer(.3), "timeout")
	$part1.visible = false
	$part2.visible = true
	$AnimationPlayer.play("part2_entrance")
	yield(get_tree().create_timer(3), "timeout")
	$AnimationPlayer.play("part2_exit")
	changingscene = true
	transition_enter()
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().change_scene_to(mainmenu)

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept") and changingscene == false:
		transition_enter()
		yield(get_tree().create_timer(.5), "timeout")
		get_tree().change_scene_to(mainmenu)
	
func transition_enter():
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("enter")
