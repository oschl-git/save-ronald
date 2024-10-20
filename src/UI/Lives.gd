extends NinePatchRect

func _on_HUD_lives_changed(lives):
	$HBoxContainer/TextureProgress.value = lives
