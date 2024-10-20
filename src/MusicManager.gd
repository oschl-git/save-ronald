extends Node

var musicplayer
var music
var loop : = false

var music_volume : int = 80
var sound_volume : int = 100

func _ready():
	musicplayer = AudioStreamPlayer.new()
	add_child(musicplayer)
	musicplayer.bus = "music"
	musicplayer.connect("finished", self, "on_playback_finished")

func change_music(newmusic):
	loop = true
	if music != newmusic:
		music = newmusic
		musicplayer.set_stream(music)
		musicplayer.play()
	
func change_music_no_loop(newmusic):
	loop = false
	if music != newmusic:
		music = newmusic
		musicplayer.set_stream(music)
		musicplayer.play()
	
func change_music_with_prelude(newprelude, newmusic):
	loop = true
	if music != newmusic:
		music = newmusic
		musicplayer.set_stream(newprelude)
		musicplayer.play()

func stop_music():
	loop = false
	musicplayer.stop()

func on_playback_finished():
	if loop: musicplayer.play()
	else: musicplayer.stop()
	
func change_music_volume(new_music_volume):
	music_volume = new_music_volume
	var volumedb : float = float(music_volume) / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(volumedb))

func change_sound_volume(new_sound_volume):
	sound_volume = new_sound_volume
	var volumedb : float = float(sound_volume) / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sounds"), linear2db(volumedb))
