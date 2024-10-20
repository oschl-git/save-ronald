extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL : = Vector2.UP
export var gravity : = 1000.0
var velocity : = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
