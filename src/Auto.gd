extends Node

const VERSION = "0.1.0"

var current_level : int
var current_level_name : String
var current_chapter_name : String

var input : = 0 #Used to determine whether a controller is being used.

signal inputchange() #Signals if the input has been changed

func _ready():
	self.set_pause_mode(PAUSE_MODE_PROCESS)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	OS.set_window_size(Vector2(1280, 720))

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		GameSaving.settings_data["fullscreen"] = OS.window_fullscreen
		GameSaving.save_settings()
	
	if event.is_action_pressed("keyboard_input") and input != 0:
		input = 0
		emit_signal("inputchange")
	
	if event.is_action_pressed("controller_input") and input != 1:
		input = 1
		emit_signal("inputchange")
