extends Control

func _ready():
	$Back.grab_focus()
	
	var text : String
	
	if GameSaving.user_data["full_game_time"] == null: text += "full game trial: no time\n\n"
	else: text += "full game trial: " + TimeTrial.convert_ms_to_time(GameSaving.user_data["full_game_time"]) + "\n\n"
	
	for x in 8:
		if x+1 in GameSaving.user_data["level_times"]: text += ("level " + str(x + 1) + ": " +
			TimeTrial.convert_ms_to_time(GameSaving.user_data["level_times"][x+1]) + "\n")
		else: text += "level " + str(x + 1) + ": no time\n" 
	
	$Highscores.text = text

func _input(event):
	if event.is_action_pressed("ui_cancel"): get_tree().change_scene("res://src/UI/MainMenu.tscn")

func _on_Back_pressed():
	get_tree().change_scene("res://src/UI/MainMenu.tscn")
