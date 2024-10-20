extends Control
var shown : = false

func _on_Madfat_health_updated(health):
	$Background/Bar.value = health

func _on_Madfat_death():
	if shown == true:
		$AnimationPlayer.play("hide")
		shown = false

func _on_Madfat_show_health_bar():
	if shown == false: 
		$AnimationPlayer.play("show")
		shown = true
