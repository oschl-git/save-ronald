extends Actor

class_name Redfat

export var direction : = 1
export var walkspeed : = 40
export var chargespeed : = 150
export var lives : = 4
var bluefat : = false
var charging : = false
var stunned : = false
var isdead : = false

func _ready():
	set_physics_process(false)
	if direction == -1:
		change_direction()
		
func _on_VisibilityEnabler2D_screen_entered():
	set_physics_process(true)

func _physics_process(delta):
	if is_on_wall() and charging and bluefat == false: stunned()
	
	elif (is_on_wall() or not $FloorChecker.is_colliding()) and is_on_floor():
		if charging == false:
			direction = direction * -1
			change_direction()

	if $PlayerChecker.is_colliding() and stunned == false:
		charging = true
	
	if lives <= 0: death()
	check_danger_collision()
	
	if is_on_floor() and isdead:
		set_physics_process(false)
	
	charge_animation()
	
	velocity.x = chargespeed * direction if charging else walkspeed * direction
	if isdead == false: velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
	if charging == false and stunned == false and $walk.playing == false:
		$walk.play()
		$charge.stop()
	
	if charging == true and stunned == false and $charge.playing == false:
		$charge.play()
		
	if charging == false:
		$charge.stop()

func change_direction():
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $FloorChecker.position.x * -1
		$PlayerChecker.cast_to.x = $PlayerChecker.cast_to.x * -1

func charge_animation():
	if charging == true and isdead == false:
		$AnimatedSprite.play("charging")

func stunned():
	stunned = true
	$Light
	var prevdirection = direction
	charging = false
	direction = 0
	$AnimatedSprite.play("stunned")
	if isdead: return
	yield(get_tree().create_timer(2, false), "timeout")
	if isdead: return
	$AnimatedSprite.play("walking")
	direction = prevdirection
	stunned = false

func _on_DeathArea_area_entered(area):
	if "Bullet" in area.name:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("hit")
		$hurt.play()
		lives -= 1

func death():
	stunned = false
	charging = false
	isdead = true
	direction = 0
	$AnimatedSprite.play("death")
	$LightOccluder2D.visible = false
	$CollisionShape2D.disabled = true
	$DeathArea/DeathAreaCollisionShape2D.disabled = true

func check_danger_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("danger"):
			$hurt.play()
			death()
