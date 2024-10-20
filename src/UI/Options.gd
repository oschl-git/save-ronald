extends Control

onready var parent = get_parent()
var optionsopened : = false
var userdataconf : = false

signal optionsclosed()

func _ready():
	$Buttons/Fullscreen.grab_focus()
	parent.connect("openoptions", self, "options_opened")
	
func _input(event):
	if event.is_action_pressed("ui_cancel") and optionsopened:
		if userdataconf:
			$button_press.play()
			userdataconf = false
			enable_buttons()
			$Buttons/UserData/Label.text = "remove saved data"
		else: close_options()
		
	if event.is_action_pressed("ui_accept") and optionsopened and userdataconf:
		$button_press.play()
		userdataconf = false
		disable_buttons()
		GameSaving.remove_data()
		GameSaving.load_data()
		enable_buttons()
		$Buttons/UserData.grab_focus()
		$Buttons/UserData/Label.text = "saved data removed"
		$Buttons/UserData.disabled = true

func options_opened():
	$ui1.play()
	
	if OS.window_fullscreen: $Buttons/Fullscreen/Label.text = "fullscreen: on"
	else: $Buttons/Fullscreen/Label.text = "fullscreen: off"
	
	$Buttons/MusicVolume/Label.text = "music volume: " + str(MusicManager.music_volume)
	$Buttons/SoundVolume/Label.text = "sound volume: " + str(MusicManager.sound_volume)
	
	if OS.vsync_enabled: $Buttons/Vsync/Label.text = "vsync: on"
	else: $Buttons/Vsync/Label.text = "vsync: off"
	
	if GameSaving.settings_data["FPS"]: $Buttons/FPS/Label.text = "show fps: on"
	else: $Buttons/FPS/Label.text = "show fps: off"
	
	visible = true
	optionsopened = true
	enable_buttons()
	$AnimationPlayer.play("entrance")
	$Buttons/Fullscreen.grab_focus()
	
	
func _on_Fullscreen_pressed():
	$button_press.play()
	
	OS.window_fullscreen = !OS.window_fullscreen
	
	if OS.window_fullscreen: $Buttons/Fullscreen/Label.text = "fullscreen: on"
	else: $Buttons/Fullscreen/Label.text = "fullscreen: off"
	
	GameSaving.settings_data["fullscreen"] = OS.window_fullscreen


func _on_MusicVolume_pressed():
	$button_press.play()
	if MusicManager.music_volume == 100: MusicManager.music_volume = 0
	else: MusicManager.music_volume += 10
	MusicManager.change_music_volume(MusicManager.music_volume)
	$Buttons/MusicVolume/Label.text = "music volume: " + str(MusicManager.music_volume)
	
	GameSaving.settings_data["music_volume"] = MusicManager.music_volume

func _on_SoundVolume_pressed():
	$button_press.play()
	if MusicManager.sound_volume == 100: MusicManager.sound_volume = 0
	else: MusicManager.sound_volume += 10
	MusicManager.change_sound_volume(MusicManager.sound_volume)
	$Buttons/SoundVolume/Label.text = "sound volume: " + str(MusicManager.sound_volume)
	
	GameSaving.settings_data["sound_volume"] = MusicManager.sound_volume

func _on_Vsync_pressed():
	$button_press.play()
	
	OS.vsync_enabled = !OS.vsync_enabled
	
	if OS.vsync_enabled: $Buttons/Vsync/Label.text = "vsync: on"
	else: $Buttons/Vsync/Label.text = "vsync: off (not recommended)"
	
	GameSaving.settings_data["vsync"] = OS.vsync_enabled

func _on_FPS_pressed():
	$button_press.play()
	
	GameSaving.settings_data["FPS"] = !GameSaving.settings_data["FPS"]
	
	if GameSaving.settings_data["FPS"]: $Buttons/FPS/Label.text = "show fps: on"
	else: $Buttons/FPS/Label.text = "show fps: off"

func _on_UserData_pressed():
	$button_press.play()
	if File.new().file_exists(GameSaving.save_path):
		userdataconf = true
		disable_buttons()
		$Buttons/UserData.focus_mode = FOCUS_ALL
		$Buttons/UserData/Label.text = "are you sure? ([ESC] or (B) to cancel)"
		$Buttons/UserData.grab_focus()
	else:
		$Buttons/UserData/Label.text = "no save file found"
		$Buttons/UserData.disabled = true


func _on_Back_pressed(): close_options()

func close_options():
	GameSaving.save_settings()
	$ui2.play()
	optionsopened = false
	disable_buttons()
	emit_signal("optionsclosed")
	$AnimationPlayer.play("exit")
	yield(get_tree().create_timer(.5, false), "timeout")
	visible = false

func disable_buttons():
	$Buttons/Fullscreen.focus_mode = FOCUS_NONE
	$Buttons/MusicVolume.focus_mode = FOCUS_NONE
	$Buttons/SoundVolume.focus_mode = FOCUS_NONE
	$Buttons/Vsync.focus_mode = FOCUS_NONE
	$Buttons/FPS.focus_mode = FOCUS_NONE
	$Buttons/UserData.focus_mode = FOCUS_NONE
	$Buttons/Back.focus_mode = FOCUS_NONE
	
func enable_buttons():
	$Buttons/Fullscreen.focus_mode = FOCUS_ALL
	$Buttons/MusicVolume.focus_mode = FOCUS_ALL
	$Buttons/SoundVolume.focus_mode = FOCUS_ALL
	$Buttons/Vsync.focus_mode = FOCUS_ALL
	$Buttons/FPS.focus_mode = FOCUS_ALL
	$Buttons/UserData.focus_mode = FOCUS_ALL
	$Buttons/Back.focus_mode = FOCUS_ALL

#Label animations
func _on_Fullscreen_focus_entered():$Buttons/Fullscreen/AnimationPlayer.play("select")
func _on_Fullscreen_focus_exited():$Buttons/Fullscreen/AnimationPlayer.play("deselect")

func _on_MusicVolume_focus_entered(): $Buttons/MusicVolume/AnimationPlayer.play("select")
func _on_MusicVolume_focus_exited():$Buttons/MusicVolume/AnimationPlayer.play("deselect")

func _on_SoundVolume_focus_entered(): $Buttons/SoundVolume/AnimationPlayer.play("select")
func _on_SoundVolume_focus_exited(): $Buttons/SoundVolume/AnimationPlayer.play("deselect")

func _on_Vsync_focus_entered(): $Buttons/Vsync/AnimationPlayer.play("select")
func _on_Vsync_focus_exited(): $Buttons/Vsync/AnimationPlayer.play("deselect")

func _on_UserData_focus_entered(): $Buttons/UserData/AnimationPlayer.play("select")
func _on_UserData_focus_exited(): $Buttons/UserData/AnimationPlayer.play("deselect")

func _on_Back_focus_entered(): $Buttons/Back/AnimationPlayer.play("select")
func _on_Back_focus_exited(): $Buttons/Back/AnimationPlayer.play("deselect")

func _on_FPS_focus_entered(): $Buttons/FPS/AnimationPlayer.play("select")
func _on_FPS_focus_exited(): $Buttons/FPS/AnimationPlayer.play("deselect")
