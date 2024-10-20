extends Node

func _ready():
	self.set_pause_mode(PAUSE_MODE_PROCESS)
	
	#Load and apply saved user data at the start of the game:
	load_data()
	load_settings()
	
	OS.window_fullscreen = settings_data["fullscreen"]
	
	MusicManager.music_volume = settings_data["music_volume"]
	MusicManager.sound_volume = settings_data["sound_volume"]
	MusicManager.change_music_volume(MusicManager.music_volume)
	MusicManager.change_sound_volume(MusicManager.sound_volume)
	
	OS.vsync_enabled = settings_data["vsync"]
	
	OS.set_window_position(OS.get_screen_size() * 0.5 - OS.get_real_window_size() * 0.5)

#Game progress
var save_path = "user://save.dat"

var user_data = {
	"unlocked_levels" : 0,
	"level_times" : {},
	"chapter_times" : {},
	"full_game_time" : 0
}

var levels : = [
	"res://levels/level1.tscn",
	"res://levels/level2.tscn",
	"res://levels/level3.tscn",
	"res://levels/level4.tscn",
	"res://levels/level5.tscn",
	"res://levels/level6.tscn",
	"res://levels/level7.tscn",
	"res://levels/level8boss.tscn",
]

var level_times : Dictionary

func save_data():
	var file = File.new()
	var result = file.open_encrypted_with_pass(save_path, File.WRITE, "MR2Zu.L=kF7fMW2~")
	if result == OK:
		file.store_var(user_data)
		file.close()
	else: print("Failed to save user data.")
	
func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var result = file.open_encrypted_with_pass(save_path, File.READ, "MR2Zu.L=kF7fMW2~")
		if result == OK:
			user_data = file.get_var() 
			file.close()
		else: print("Failed to load user data.")

func remove_data():
	var dir = Directory.new()
	dir.remove(save_path)
	user_data = {
	"unlocked_levels" : 0,
	"level_times" : {},
	"chapter_times" : {},
	"full_game_time" : 0
	}

func change_unlocked_levels(unlockedlevels):
	user_data["unlocked_levels"] = unlockedlevels
	save_data()

#Settings
var settings_path = "user://settings.dat"
var settings_data = {
	"fullscreen" : true,
	"music_volume" : 80,
	"sound_volume" : 100,
	"vsync" : true,
	"FPS" : false,
}

func save_settings():
	var file = File.new()
	var result = file.open(settings_path, File.WRITE)
	if result == OK:
		file.store_var(settings_data)
		file.close()
	else: print("Failed to save user configuration.")

func load_settings():
	var file = File.new()
	if file.file_exists(settings_path):
		var result = file.open(settings_path, File.READ)
		if result == OK:
			settings_data = file.get_var() 
			file.close()
		else: print("Failed to load user configuration.")
