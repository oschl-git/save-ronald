extends StaticBody2D

var closed : = false

func _ready():
	$AnimatedSprite.playing = false
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

var activated : = false
func _on_ActivationArea_body_entered(body):
	if closed == false and activated == false:
		activated = true
		visible = true
		closed = true
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite.playing = true
		$AnimatedSprite.play("openclose")
		yield(get_tree().create_timer(0.01, false), "timeout")

func _on_Madfat_death():
	if closed == true:
		closed = false
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("openclose", true)
		yield(get_tree().create_timer(0.01, false), "timeout")
		queue_free()
