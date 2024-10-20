extends Area2D

export var type : = 1

signal keycollected(type)

func _ready():
	if type == 1: $AnimatedSprite.play("red")
	if type == 2: $AnimatedSprite.play("yellow")
	if type == 3: $AnimatedSprite.play("blue")
	if type == 4: $AnimatedSprite.play("green")

func _on_KeyPickup_body_entered(body):
	$CollisionShape2D.set_deferred('disabled', true)
	emit_signal("keycollected", type)
	$key_pickup.play()
	$AnimatedSprite.play("collected")
	$AnimationPlayer.play("collected")
