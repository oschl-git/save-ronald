extends Area2D
class_name Bullet

const SPEED = 400
var velocity : = Vector2.ZERO
var direction : = Vector2(1, 0)

func _physics_process(delta):
	velocity = Vector2(SPEED * delta * direction.x, SPEED * delta * direction.y)
	translate(velocity)
	
func set_bullet_direction(dir):
	direction = dir
	if direction.x == -1: $AnimatedSprite.flip_h = true
	if direction.y == -1:
		rotation_degrees = -90
		$AnimatedSprite.flip_v = true
	if direction.y == 1:
		rotation_degrees = 90

func _on_Bullet_body_entered(body): if body is KinematicBody2D == false: destroy()
func _on_Bullet_area_entered(area): destroy()

func destroy():
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	$AnimationPlayer.play("destroy")
