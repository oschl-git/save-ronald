extends Area2D

func _on_HeartPickup_body_entered(body):
	$CollisionShape2D.set_deferred('disabled', true)
	$life_pickup.play()
	$AnimatedSprite.play("collected")
	$AnimationPlayer.play("collected")
