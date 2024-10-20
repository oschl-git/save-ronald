extends Area2D

func _on_AmmoPickup_body_entered(body):
	$CollisionShape2D.set_deferred('disabled', true)
	$ammo_pickup.play()
	$AnimatedSprite.play("collected")
	$AnimationPlayer.play("collected")
