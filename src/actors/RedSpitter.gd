extends Sprite

const ENEMYBULLET = preload("res://src/other/EnemyBullet.tscn")
export var vertical : = false
export var flipped : = false
export var frequency : = 1.0
export var waittime : = 0.0
var direction : = Vector2(1, 0)
var bulletposition : = Vector2.ZERO
var shoottimer : Timer

func _ready():
	if flipped and vertical == false:
		direction.x = -1
		flip_h = true
		$LightOccluder2D.rotation_degrees = 180
		
	if flipped == false and vertical:
		rotation_degrees = 90
		$LightOccluder2D.rotation_degrees = 90
		direction = Vector2(0, 1)
		
	if flipped == true and vertical:
		rotation_degrees = -90
		$LightOccluder2D.rotation_degrees = -90
		direction = Vector2(0, -1)
	
	set_up_pos_and_dir()
	set_up_shoot_timer()
	
	yield(get_tree().create_timer(waittime, false), "timeout")
	shoottimer.start()

func set_up_shoot_timer():
	shoottimer = Timer.new()
	shoottimer.set_wait_time(frequency)
	shoottimer.connect("timeout", self, "on_shoot_timer_complete")
	add_child(shoottimer)

func on_shoot_timer_complete():
	var enemybullet = ENEMYBULLET.instance()
	enemybullet.set_bullet_direction(direction)
	get_parent().add_child(enemybullet)
	enemybullet.position = bulletposition
	$shoot.play()
	shoottimer.start()
	
func set_up_pos_and_dir():
	if vertical:
		bulletposition = Vector2(position.x, position.y - 7 if flipped else position.y + 7)
	if vertical == false:
		bulletposition = Vector2(position.x - 7 if flipped else position.x + 7, position.y)
