extends NinePatchRect

func _on_HUD_ammo_changed(ammo):
	if str(ammo) == "inf":
		visible = false
	elif ammo == 0:
		$red_zero.visible = true
		$Label.visible = false
	elif ammo > 0:
		$red_zero.visible = false
		$Label.visible = true
		$Label.text = "%s" % ammo
