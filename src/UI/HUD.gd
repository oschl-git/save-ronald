extends Control

export var level_text : String
export var level_music : AudioStreamOGGVorbis
signal lives_changed(lives)
signal ammo_changed(ammo)
signal keys_changed(type)

func _ready():
	var player = get_node("../../Objects/Player")
	player.connect("playerlives", self, "player_lives_changed")
	player.connect("playerammo", self, "player_ammo_changed")
	player.connect("playerkeys", self, "player_keys_changed")
	
	var transition = load("res://src/UI/SwipeTransition.tscn").instance()
	add_child(transition)
	transition.get_node("AnimationPlayer").play("exit")
	
	if TimeTrial.time_trial == false:
		$LevelText.text = level_text
		$ColorRect.visible = true
		$LevelText.visible = true
	
	if TimeTrial.time_trial: $TimeTrialTimer.visible = true
	else: $TimeTrialTimer.visible = false
	
	if TimeTrial.time_trial and TimeTrial.level: TimeTrial.start_time_trial()
	
	MusicManager.change_music(level_music)
	
	$version.text = Auto.VERSION
	
	Auto.current_level_name = level_text
	
func _process(delta):
	if GameSaving.settings_data["FPS"]:
		$FPS.visible = true
		$FPS.text = "%s" % Engine.get_frames_per_second()
	else: $FPS.visible = false

func player_lives_changed(lives):
	emit_signal("lives_changed", lives)

func player_ammo_changed(ammo):
	emit_signal("ammo_changed", ammo)

func player_keys_changed(type):
	emit_signal("keys_changed", type)

func _on_AnimationPlayer_animation_finished(anim_name):
	$ColorRect.visible = false
	$LevelText.visible = false
