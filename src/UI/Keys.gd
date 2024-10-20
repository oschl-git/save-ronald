extends NinePatchRect

func _on_HUD_keys_changed(type):
	$keys_background/red.visible = type[0]
	$keys_background/yellow.visible = type[1]
	$keys_background/blue.visible = type[2]
	$keys_background/green.visible = type[3]
	
	if visible == false and (type[0] or type[1] or type[2] or type[3]):
		visible = true
		$AnimationPlayer.play("show")
	elif visible and (type[0] == false and type[1] == false and type[2] == false and type[3] == false):
		$AnimationPlayer.play("hide")
		yield ($AnimationPlayer, "animation_finished")
		visible = false
